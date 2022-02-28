//
//  MessagesView.swift
//  Amore
//
//  Created by Piyush Garg on 04/02/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import StreamChat

struct AllConversationsView: View {
    
    @Binding var navigateToChatView: Bool
    @State var toUser: ChatUser = ChatUser()
    @EnvironmentObject var chatModel: ChatModel
    @EnvironmentObject var mainMessagesModel: MainMessagesViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(mainMessagesModel.recentChats.sorted(by: { $0.timeAgo < $1.timeAgo })) { recentMessage in
                    VStack {
                        Button {
                            self.toUser = recentMessage.user ?? ChatUser()
                            self.chatModel.fetchMessages(toUser: toUser)
                            self.navigateToChatView = true
                            mainMessagesModel.markMessageRead(chat: recentMessage)
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
                            .padding(.vertical, 8)
                    }.padding(.horizontal)
                    
                }.padding(.bottom, 50)
                if (mainMessagesModel.recentChats.count == 0) {
                        HStack{
                            Spacer()
                        }
                    }
            }
            
            NavigationLink("", isActive: $navigateToChatView) {
                ConversationView(toUser: $toUser)
                    .environmentObject(chatModel)
                    .environmentObject(mainMessagesModel)
            }
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
            WebImage(url: recentMessage.user?.image1?.imageURL)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipped()
                .cornerRadius(64)
                .overlay(RoundedRectangle(cornerRadius: 64)
                            .stroke(Color.black, lineWidth: 1))
                .shadow(radius: 5)
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text((recentMessage.user?.firstName.bound ?? "") + " " + (recentMessage.user?.lastName.bound ?? ""))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(.label))
                    .multilineTextAlignment(.leading)
                if recentMessage.lastText.bound.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                    Text("Be the first to break the ice!")
                        .font(.system(size: 14).italic())
                        .foregroundColor(Color(.darkGray))
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }
                else {
                    Text(recentMessage.lastText.bound)
                        .font(.system(size: 14))
                        .foregroundColor(Color(.darkGray))
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
