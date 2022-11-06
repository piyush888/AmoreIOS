//
//  ChatLogView.swift
//  Amore
//
//  Created by Piyush Garg on 04/02/22.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import GiphyUISDK

struct ConversationView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Namespace var animation
    @EnvironmentObject var chatViewModel: ChatViewModel
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
    @State var presentProfileCard: Bool = false
    @Binding var navigateToChatView: Bool
    
    // Show the gif and sticker selections
    @State var isShowingGifPicker = false
    @State var giphyURL: String = ""
    @State var giphyId: String = ""
    
    // TO BE DELETED - KTZ. 
    @State var gifData: [String] = []
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                AllMessagesForUser
                    .padding(.top,10)
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                
                // TO BE DELETED - KTZ.
//                ScrollView(.vertical, showsIndicators:false, content:{
//                    ForEach(gifData,id:\.self){ url in
//                        Spacer(minLength: 0)
//                        AnimatedImage(url:URL(string:url)!)
//                            .aspectRatio(contentMode: .fit)
//                            .clipShape(GipyCustomShape())
//                    }
//                })

                MessageSendField
                    .padding([.horizontal, .bottom])
                    .ignoresSafeArea()
            }
            .fullScreenCover(isPresented: $isShowingGifPicker,
                             onDismiss: gipgyViewDismissed,
                             content:{
                                GiphyVCRepresentable(giphyURL:$giphyURL,
                                                     giphyId:$giphyId,
                                                     isShowingGifPicker:$isShowingGifPicker)
                            })
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                customNavBar(toUser: $toUser, presentProfileCard: $presentProfileCard)
                    .environmentObject(mainMessagesModel)
            }
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    // Report Button
                    Button  {
                        allcardsActiveSheet = .reportProfileSheet
                    } label: {
                        Label("Report User", systemImage: "shield.fill")
                            .font(.system(size: 60))
                    }
                    // Unmatch Button
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
        .onChange(of: selectedChatIndex, perform: { newValue in
            /*
             ErrorSolved: sending new message rearranged positions of chats in "recentChats" array
             causing change in selectedChatIndex, further causing exit from ConversationView
             
             SolvedBy: Condition to check if new value of selectedChatIndex is negative(removed chat) or not
             */
            if (newValue < 0) {
                /* When Unmatched from chat, other user should exit chat automatically.
                 selectedChatIndex for other user in this case becomes -1, since the chat doesn't exist anymore.
                 */
                navigateToChatView = false
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
        // Profile Card on tap on Profile Picture
        .sheet(isPresented: $presentProfileCard) {
            if let userId = toUser.id {
                CardDetail(selectedItem: mainMessagesModel.getProfile(profileId: userId), show: $presentProfileCard, animation: animation)
            }
        }
    }
    
    private var AllMessagesForUser: some View {
        ScrollViewReader { scrollViewProxy in
            ReverseScrollView(.vertical) {
                ForEach(chatViewModel.chatMessages.sorted(by: { $0.timestamp ?? Date() > $1.timestamp ?? Date()}), id: \.self) { message in
                    MessageView(message: message, toUser: toUser)
                        .environmentObject(chatViewModel)
                        .id(message.id)
                        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                        .onAppear {
                            if chatViewModel.shouldFetchMoreMessages(message: message) {
                                chatViewModel.fetchMoreMessages(toUser: toUser)
                            }
                        }
                }
                .padding(.top, 10)
            }
            // Scroll to Bottom code
            .onChange(of: scrollToBottomOnSend) { newValue in
                if newValue == true {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            scrollViewProxy.scrollTo(chatViewModel.chatMessages.last?.id)
                        }
                        print ("Chat: Checkpoint 8")
                    }
                    print("Chat: ChatMessages Count = \(chatViewModel.chatMessages.count)")
                    scrollToBottomOnSend = false
                }
            }
        }
    }
    
    private var emptyTextBoxPlaceHolder: String {
        if allowDirectMessageSendCondition {
            return ""
        }
        else {
            return "You made your move, cheers !!"
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
        if selectedChatIndex < 0 {
            return false
        }
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
        if selectedChatIndex < 0 {
            return false
        }
        if !mainMessagesModel.recentChats[selectedChatIndex].directMessageApproved && (mainMessagesModel.recentChats[selectedChatIndex].toId == Auth.auth().currentUser?.uid) {
            return true
        }
        else {
            return false
        }
    }
    
    private var MessageSendField: some View {
        HStack(spacing: 16) {
            
            Button {
                self.isShowingGifPicker = true
            } label:{
                Image(systemName:"paperclip")
                    .resizable()
                    .frame(width:20, height:20)
                    .foregroundColor(sendButtonColor)
            }
            .disabled(!allowDirectMessageSendCondition)
            
            /**
             New Text box Implementation with Placeholder and auto expanding Text Box
             */
            TextEditorWithPlaceholder(text: $chatViewModel.chatText, placeholder: emptyTextBoxPlaceHolder)
                .disabled(!allowDirectMessageSendCondition)
            
            Button {
                scrollToBottomOnSend = true
                chatViewModel.handleSend(fromUser: mainMessagesModel.fromUser, toUser: self.toUser, directMessage: false, type:"text")
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
    
    // Once the giphy disappears
    // If giphyURL != nil and giphyId !=nil
    /// Store the data in the firestore
    // Else: User didn't select a GIF and no need to update the messages
    func gipgyViewDismissed() {
        if((self.giphyId != "") && (self.giphyURL != "")) {
            // Create a chat model obejct and push the document on it
            print("Store data in firestore")
            chatViewModel.giphyId = self.giphyId
            chatViewModel.handleSend(fromUser: mainMessagesModel.fromUser, toUser: self.toUser, directMessage: false, type:"giphy")
            
            // Create a ChatModel object
            // Handle the send
            // Update the recent messages
            // Load the GIF content in chat
            
            self.gifData.append(self.giphyURL) // TO BE DELETED - KTZ.
            self.giphyId = ""
            self.giphyURL = ""
        }
    }
    
}

struct MessageView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    let message: ChatModel
    var toUser: ChatUser
    
    var body: some View {
        
        VStack {
            switch message.type {
                case "text":
                    // Cirremt User
                    if message.fromId == Auth.auth().currentUser?.uid {
                        ChatBubble(direction: .right) {
                            Text(message.text.bound)
                                .foregroundColor(.white)
                                .padding(.all, 20)
                                .background(Color.blue)
                        }
                    } else {
                        // Messages received from other user
                        HStack(alignment: .bottom, spacing: 10) {
                            WebImage(url: toUser.image1?.imageURL)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipped()
                                .cornerRadius(40)
                                .shadow(radius: 1)
                            ChatBubble(direction: .left) {
                                Text(message.text.bound)
                                    .padding(.all, 20)
                                    .background(colorScheme == .dark ? Color.gray.opacity(0.4): Color(.init(white: 0.95, alpha: 1)))
                            }
                        }
                    } // end of switch case
                    
                case "giphy":
                    if let gifMediaId = message.giphyId {
                        if message.fromId == Auth.auth().currentUser?.uid {
                            ChatBubble(direction: .right) {
                                Text(gifMediaId ?? "")
                                    .padding(.all, 20)
                                // TODO : MAKE use of the mediaId to load the gif here.
                                
//                                AnimatedImage(url:chatViewModel.loadGifURL(giphyID: gifMediaId))
//                                    .aspectRatio(contentMode: .fit)
//                                    .clipShape(GipyCustomShape())
                                
// TODO - THIS IS THE FUNCTION WE MADE FOR FETCING PROFILE FROM GIPHY USING ID
//        func loadGifURL(giphyID:String) -> URL{
//            GiphyCore.shared.gifByID(giphyID) { (response, error) in
//                if let media = response?.data {
//                    DispatchQueue.main.sync {
//                        let gifURL = media.url(rendition: giphyViewController.renditionType, fileType: .gif) ?? ""
//                        return URL(string: gifURL ?? "")
//
//                    }
//                }
//            }
//        }
                        }
                    }
                        else {
                        // Messages received from other user
                        HStack(alignment: .bottom, spacing: 10) {
                            WebImage(url: toUser.image1?.imageURL)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipped()
                                .cornerRadius(40)
                                .shadow(radius: 1)
                            // TODO : MAKE use of the mediaId to load the gif here.
//                            AnimatedImage(url:chatViewModel.loadGifURL(giphyID: gifMediaId))
//                                .aspectRatio(contentMode: .fit)
//                                .clipShape(GipyCustomShape())
                        }
                    }
                } // end of switch case
                    
                default:
                    Text("")
            }
        }
        .padding(.horizontal)
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(toUser: Binding.constant(ChatUser(id: "123", firstName: "Piyush", lastName: "Garg", image1: ProfileImage())), selectedChat: Binding.constant(ChatConversation(id: "1", fromId: "123", toId: "456", user: ChatUser(id: "123", firstName: "Piyush", lastName: "Garg", image1: ProfileImage()), lastText: "abc", timestamp: Date(), msgRead: true, otherUserUpdated: true, directMessageApproved: true)), navigateToChatView: Binding.constant(true))
            .environmentObject(ChatViewModel())
            .environmentObject(MainMessagesViewModel())
    }
}
