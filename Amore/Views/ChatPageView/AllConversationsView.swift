//
//  MessagesView.swift
//  Amore
//
//  Created by Piyush Garg on 04/02/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct AllConversationsView: View {
    
    @Binding var navigateToChatView: Bool
    @State var toUser: ChatUser = ChatUser()
    @State var selectedChat = ChatConversation()
    @EnvironmentObject var chatModel: ChatModel
    @EnvironmentObject var mainMessagesModel: MainMessagesViewModel
    @EnvironmentObject var tabModel: TabModel
    
    var body: some View {
        VStack(spacing: 10) {
            Divider()
                .opacity(0)
            ScrollView {
                ForEach(mainMessagesModel.recentChats.sorted(by: { $0.timeAgo < $1.timeAgo })) { recentMessage in
                    VStack {
                        Button {
                            self.toUser = recentMessage.user ?? ChatUser()
                            self.chatModel.fetchMessages(toUser: toUser)
                            self.navigateToChatView = true
                            self.selectedChat = recentMessage
                            mainMessagesModel.markMessageRead(chat: recentMessage)
//                            tabModel.showDetail.toggle()
                        } label: {
                            if (recentMessage.fromId == Auth.auth().currentUser?.uid) {
                                IndividualMessageRow(recentMessage: recentMessage)
                            }
                            else {
                                if (recentMessage.msgRead ?? true) {
                                    IndividualMessageRow(recentMessage: recentMessage)
                                }
                                else {
                                    IndividualMessageRow(recentMessage: recentMessage)
                                        .overlay(Text("\(Image(systemName: "suit.heart.fill"))")
                                                    .foregroundColor(.green)
                                                    .font(.body), alignment: .bottomTrailing)
                                }
                            }
                        }

                        Divider()
                            .padding(.bottom, 5)
                    }
                    .padding(.horizontal)
                }
                
                if (mainMessagesModel.recentChats.count == 0) {
                        HStack{
                            Spacer()
                        }
                    }
            }
            
            NavigationLink("", isActive: $navigateToChatView) {
                ConversationView(toUser: $toUser, selectedChat: $selectedChat, navigateToChatView: $navigateToChatView)
                    .environmentObject(chatModel)
                    .environmentObject(mainMessagesModel)
                    .onDisappear {
                        chatModel.firestoreListener?.remove()
//                        withAnimation(.easeInOut) {
//                            tabModel.showDetail.toggle()
//                        }
                    }
            }
        }
//        .padding(.top, 10)
        .onAppear {
            print("Chat: USER ID FOR THIS USER: \(Auth.auth().currentUser?.uid)")
        }
        
    }
}

struct IndividualMessageRow: View {
    
    var recentMessage: ChatConversation
    
    var body: some View {
        HStack(spacing: 16) {
            WebImage(url: recentMessage.user?.image1?.imageURL)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipped()
                .cornerRadius(64)
                .shadow(radius: 3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text((recentMessage.user?.firstName.bound ?? "") + " " + (recentMessage.user?.lastName.bound ?? ""))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(.label))
                    .multilineTextAlignment(.leading)
                if recentMessage.lastText.bound.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                    Text("Be the first to break the ice!")
                        .font(.system(size: 14).italic())
                        .foregroundColor(Color(.label))
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }
                else {
                    Text(recentMessage.lastText.bound)
                        .font(.system(size: 14))
                        .foregroundColor(Color(.label))
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }
            }
            Spacer()
            
            Text(recentMessage.timeAgo)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(.label))
        }
    }
}

struct AllConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        AllConversationsView(navigateToChatView: Binding.constant(false))
            .environmentObject(ChatModel())
            .environmentObject(MainMessagesViewModel())
    }
}
