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
            
            List {
                ForEach(mainMessagesModel.recentChats) { recentMessage in

                    if let toUser = recentMessage.user {
                        NavigationLink {
                            ConversationView(toUser: toUser, selectedChat: recentMessage)
                                .environmentObject(chatViewModel)
                                .environmentObject(mainMessagesModel)
                                .onDisappear {
                                    chatViewModel.firestoreListener?.remove()
                                    tabModel.showDetail = false
                                }
                                .onAppear {
                                    tabModel.showDetail = true
                                    DispatchQueue.main.async {
                                        mainMessagesModel.markMessageRead(chat: recentMessage)
                                        self.chatViewModel.fetchMessages(toUser: toUser)
                                    }
                                }
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

                    }

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
            .listStyle(PlainListStyle())
            .background(Color.white)

        }
        .onAppear {
            print("Chat: USER ID FOR THIS USER: \(Auth.auth().currentUser?.uid)")
        }
        
    }
}

struct IndividualMessageRow: View {
    
    var recentMessage: ChatConversation
    
    var body: some View {
        HStack(spacing: 16) {

            CustomAsyncImage(url: recentMessage.user?.image1?.imageURL, placeholder: {
                ProgressView()
            })
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
