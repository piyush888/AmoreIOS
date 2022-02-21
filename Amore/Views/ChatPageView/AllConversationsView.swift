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
                ForEach(mainMessagesModel.recentChats) { recentMessage in
                    VStack {
                        Button {
                            self.toUser = recentMessage.user ?? ChatUser()
                            self.chatModel.fetchMessages(toUser: toUser)
                            self.navigateToChatView = true
                        } label: {
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
                                    Text(recentMessage.lastText.bound)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.darkGray))
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                }
                                Spacer()
                                
                                Text(recentMessage.timeAgo)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(.label))
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

struct AllConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        AllConversationsView(navigateToChatView: Binding.constant(false))
            .environmentObject(ChatModel())
            .environmentObject(MainMessagesViewModel())
    }
}
