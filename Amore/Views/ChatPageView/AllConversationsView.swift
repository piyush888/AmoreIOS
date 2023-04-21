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
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var mainMessagesModel: MainMessagesViewModel
    @EnvironmentObject var tabModel: TabModel
    
    var body: some View {
        VStack(spacing: 10) {
            Divider()
                .opacity(0)
            ScrollView {
                ForEach(mainMessagesModel.recentChats.sorted(by: { $0.timestamp.boundDate > $1.timestamp.boundDate })) { recentMessage in
                    VStack {
                        Button {
                            self.toUser = recentMessage.user ?? ChatUser()
                            self.chatViewModel.fetchMessages(toUser: toUser)
                            self.navigateToChatView = true
                            self.selectedChat = recentMessage
                            mainMessagesModel.markMessageRead(chat: recentMessage)
                            // Hide control center
                            tabModel.showDetail = true
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
                    VStack {
                        Spacer()
                        Text("Oh oh!! You don't have any matches yet.")
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    .padding(25)
                }
            }
            
            NavigationLink("", isActive: $navigateToChatView) {
                ConversationView(toUser: $toUser, selectedChat: $selectedChat, navigateToChatView: $navigateToChatView)
                    .environmentObject(chatViewModel)
                    .environmentObject(mainMessagesModel)
                    .onDisappear {
                        chatViewModel.firestoreListener?.remove()
                        // Show Control Center
                        tabModel.showDetail = false
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
            
            Text(recentMessage.timestamp?.descriptiveStringForDate() ?? "")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(.label))
        }
    }
}

struct AllConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        AllConversationsView(navigateToChatView: Binding.constant(false))
            .environmentObject(ChatViewModel())
            .environmentObject(MainMessagesViewModel())
            .environmentObject(TabModel())
    }
}
