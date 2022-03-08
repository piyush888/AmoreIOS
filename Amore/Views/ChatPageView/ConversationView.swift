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
    
    var body: some View {
            VStack {
                AllMessagesForUser
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                VStack(spacing: 0) {
//                    Spacer()
                    MessageSendField
                        .background(Color.white.ignoresSafeArea())
                }
            }
            .navigationTitle(toUser.firstName ?? "")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button  {
                            
                        } label: {
                            Label("Report User", systemImage: "shield.fill")
                                .font(.system(size: 60))
                        }
                        Button  {
                            
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
            .onChange(of: mainMessagesModel.recentChats[selectedChatIndex]) { newValue in
                if newValue.fromId != Auth.auth().currentUser?.uid {
                    mainMessagesModel.markMessageRead(index: selectedChatIndex)
                }
            }
//            .navigationBarTitleDisplayMode(.inline)
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

    private var MessageSendField: some View {
        HStack(spacing: 16) {
            ZStack {
                if (chatModel.chatText.isEmpty) {
                    HStack{
                        Text("Enter Message")
                            .padding(EdgeInsets(top: 0, leading: 4, bottom: 4, trailing: 0))
                        Spacer()
                    }
                }
                TextEditor(text: $chatModel.chatText)
                    .opacity(chatModel.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)

            Button {
                scrollToBottomOnSend = true
                chatModel.handleSend(fromUser: mainMessagesModel.fromUser, toUser: self.toUser)
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
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
//        .padding(.top, 8)
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(toUser: Binding.constant(ChatUser(id: "123", firstName: "Piyush", lastName: "Garg", image1: ProfileImage())), selectedChat: Binding.constant(ChatConversation()))
            .environmentObject(ChatModel())
            .environmentObject(MainMessagesViewModel())
    }
}
