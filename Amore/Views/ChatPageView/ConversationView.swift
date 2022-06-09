//
//  ChatLogView.swift
//  Amore
//
//  Created by Piyush Garg on 04/02/22.
//

import SwiftUI
import Firebase

struct ConversationView: View {

    @EnvironmentObject var chatModel: ChatModel
    @EnvironmentObject var mainMessagesModel: MainMessagesViewModel
    @Binding var toUser: ChatUser
    @Binding var selectedChat: ChatConversation
    var selectedChatIndex: Int {
        mainMessagesModel.returnSelectedChatIndex(chat: selectedChat)
    }
    var emptyScrollToString = ""
    @State var scrollToBottomOnSend: Bool = false
    @State var allcardsActiveSheet: AllCardsActiveSheet?
    @State private var showingAlert = false
//    @State var presentReportingSheet: Bool = false
    @Binding var navigateToChatView: Bool
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                AllMessagesForUser
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                MessageSendField
                    .frame(minHeight: geo.size.height * 0.05, maxHeight: geo.size.height * 0.1, alignment: .center)
                    .padding(.horizontal)
            }
            
        }
        .navigationTitle(Text(toUser.firstName ?? ""))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button  {
                        allcardsActiveSheet = .reportProfileSheet
                    } label: {
                        Label("Report User", systemImage: "shield.fill")
                            .font(.system(size: 60))
                    }
                    Button  {
                        navigateToChatView.toggle()
                        FirestoreServices.unmatchUser(apiToBeUsed: "/unmatch", onFailure: {
                            print("Unmatch: API Call Failed")
                        }, onSuccess: {
                            print("Unmatch: API Success")
                        }, otherUserId: toUser.id)
                    } label: {
                        Label("Unmatch", systemImage: "person.crop.circle.fill.badge.xmark")
                            .font(.system(size: 60))
                    }
                }
            label: {
                Label("Options", systemImage: "ellipsis.circle")
            }
            }
        }
        .performOnChange(of: mainMessagesModel.recentChats, withKey: "selectedChatIndex", capturedValues: { oldValue, newValue in
            if oldValue.count <= newValue.count {
                if newValue[selectedChatIndex].fromId != Auth.auth().currentUser?.uid {
                    mainMessagesModel.markMessageRead(index: selectedChatIndex)
                }
            }
        })
        /// Use Report User List view for Reporting
        .sheet(item: $allcardsActiveSheet) { item in
            if let toUserId = toUser.id {
                ReportingIssuesCard(allcardsActiveSheet: $allcardsActiveSheet,
                                    profileId: toUserId,
                                    showingAlert:self.$showingAlert,
                                    onRemove: { user in
                    print("Report From Chat: API Success")
                    navigateToChatView.toggle()
                }
                )
            }
        }
        //            .onChange(of: mainMessagesModel.recentChats[selectedChatIndex]) { newValue in
        //                if newValue.fromId != Auth.auth().currentUser?.uid {
        //                    mainMessagesModel.markMessageRead(index: selectedChatIndex)
        //                }
        //            }
    }
    
    private var AllMessagesForUser: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(chatModel.chatMessages, id: \.self) { message in
                            MessageView(message: message)
                        }
                        
                        HStack{ Spacer() }
                            .frame(height: 20)
                            .id(self.emptyScrollToString)
                    }
                    .padding(.top, 10)
                    .onChange(of: chatModel.chatMessages.count) { _ in
                        print("Chat: Checkpoint 7")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                scrollViewProxy.scrollTo(self.emptyScrollToString)
                            }
                            print("Chat: Checkpoint 8")
                        }
                        print("Chat: chatMessages Count = \(chatModel.chatMessages.count)")
                    }
                    .onChange(of: scrollToBottomOnSend) { newValue in
                        if newValue == true {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    scrollViewProxy.scrollTo(self.emptyScrollToString)
                                }
                                print("Chat: Checkpoint 8")
                            }
                            print("Chat: chatMessages Count = \(chatModel.chatMessages.count)")
                            scrollToBottomOnSend = false
                        }
                    }
                }
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
        }
    }
    
    private var emptyTextBoxPlaceHolder: String {
        if allowDirectMessageSendCondition {
            return "Enter Message"
        }
        else {
            return "You made your move, now it's a waiting game"
        }
    }
    
    private var sendButtonColor: Color {
        if allowDirectMessageSendCondition {
            return Color.blue
        }
        else {
            return Color.gray
        }
    }
    
    /**
     if
     - Direct Message has been approved
     OR
     - the current user is the receiver of Direct Message
     Let the Send button and Chat Text box be activated.
     */
    private var allowDirectMessageSendCondition: Bool {
        if mainMessagesModel.recentChats[selectedChatIndex].directMessageApproved || (mainMessagesModel.recentChats[selectedChatIndex].toId == Auth.auth().currentUser?.uid) {
            return true
        }
        else {
            return false
        }
    }
    
    /**
     If
     - direct message is not approved yet
     AND
     - the current user is the receiver of direct message
     Trigger Match of two profiles on Send, when these two conditions are met simultaneously.
     */
    private var triggerMatchOnDirectMessageCondition: Bool {
        if !mainMessagesModel.recentChats[selectedChatIndex].directMessageApproved && (mainMessagesModel.recentChats[selectedChatIndex].toId == Auth.auth().currentUser?.uid) {
            return true
        }
        else {
            return false
        }
    }
    
    private var MessageSendField: some View {
        HStack(spacing: 16) {
            ZStack {
                if (chatModel.chatText.isEmpty) {
                    HStack{
                        Text(emptyTextBoxPlaceHolder)
                            .padding([.leading, .bottom], 5)
                        Spacer()
                    }
                }
                TextEditor(text: $chatModel.chatText)
                    .opacity(chatModel.chatText.isEmpty ? 0.5 : 1)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .frame(height: 40)
            .disabled(!allowDirectMessageSendCondition)
            
            Button {
                scrollToBottomOnSend = true
                chatModel.handleSend(fromUser: mainMessagesModel.fromUser, toUser: self.toUser, directMessage: false)
                if triggerMatchOnDirectMessageCondition {
                    print("Triggering Match on DM")
                    FirestoreServices.directMessageMatchUsers(apiToBeUsed: "/matchondirectmessage", onFailure: {}, onSuccess: {}, otherUserId: mainMessagesModel.recentChats[selectedChatIndex].fromId)
                }
            } label: {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .frame(width:35, height:35)
                    .foregroundColor(sendButtonColor)
                    .shadow(color: .blue,
                            radius: 0.1, x: 1, y: 1)
            }
            .disabled(!allowDirectMessageSendCondition)
        }
    }
    
}

struct MessageView: View {
    
    let message: ChatText
    
    var body: some View {
        VStack {
            if message.fromId == Auth.auth().currentUser?.uid {
                ChatBubble(direction: .right) {
                    Text(message.text.bound)
                        .foregroundColor(.white)
                        .padding(.all, 20)
                        .background(Color.blue)
                    //                        .cornerRadius(8)
                }
            } else {
                ChatBubble(direction: .left) {
                    Text(message.text.bound)
                        .foregroundColor(.black)
                        .padding(.all, 20)
                        .background(Color.white)
                    //                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(toUser: Binding.constant(ChatUser(id: "123", firstName: "Piyush", lastName: "Garg", image1: ProfileImage())), selectedChat: Binding.constant(ChatConversation()), navigateToChatView: Binding.constant(true))
            .environmentObject(ChatModel())
            .environmentObject(MainMessagesViewModel())
    }
}
