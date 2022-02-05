//
//  ChatLogView.swift
//  Amore
//
//  Created by Piyush Garg on 04/02/22.
//

import SwiftUI
import Firebase

struct ChatLogView: View {

    @EnvironmentObject var chatModel: ChatModel
    
    init(toUser: Binding<ChatUser>) {
        chatModel.toUser = toUser.wrappedValue
    }
    
    var body: some View {
            ZStack {
                messagesView
                VStack(spacing: 0) {
                    Spacer()
                    chatBottomBar
                        .background(Color.white.ignoresSafeArea())
                }
            }
            .navigationTitle(chatModel.toUser.firstName ?? "")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    chatModel.fetchMessages()
                }
//                .navigationBarHidden(false)
        }
    
    private var messagesView: some View {
            ScrollView {
                ForEach(chatModel.chatMessages) { message in
                    VStack {
                        if message.fromId == Auth.auth().currentUser?.uid {
                            HStack {
                                Spacer()
                                HStack {
                                    Text(message.text ?? "")
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                            }
                        }
                        else {
                            HStack {
                                HStack {
                                    Text(message.text ?? "")
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }

                HStack{ Spacer() }
                .frame(height: 50)
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
        }

    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack {
                if (chatModel.toUser.latestMessage.bound == "") {
                    HStack{
                        Text("Enter Message")
                            .padding(EdgeInsets(top: 0, leading: 4, bottom: 4, trailing: 0))
                        Spacer()
                    }
                }
                TextEditor(text: $chatModel.toUser.latestMessage.bound)
                    .opacity(chatModel.toUser.latestMessage.bound == "" ? 0.5 : 1)
            }
            .frame(height: 40)

            Button {
                chatModel.handleSend()
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

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLogView(toUser: Binding.constant(ChatUser(id: "123", firstName: "Piyush", lastName: "Garg", image1: ProfileImage())))
    }
}
