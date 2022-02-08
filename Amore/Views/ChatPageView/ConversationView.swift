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
    var emptyScrollToString = ""
    
    var body: some View {
            ZStack {
                AllMessagesForUser
                VStack(spacing: 0) {
                    Spacer()
                    MessageSendField
                        .background(Color.white.ignoresSafeArea())
                }
            }
            .navigationTitle(toUser.firstName ?? "")
                .navigationBarTitleDisplayMode(.inline)
//                .onAppear {
//                    chatModel.fetchMessages(toUser: toUser)
//                }
//                .navigationBarHidden(false)
        }
    
    private var AllMessagesForUser: some View {
            ScrollView {
                
                ScrollViewReader { scrollViewProxy in
                    
                    VStack {
                        ForEach(chatModel.chatMessages, id: \.self) { message in
                            VStack {
                                if message.fromId == Auth.auth().currentUser?.uid {
                                    HStack {
                                        Spacer()
                                        HStack {
                                            Text(message.text.bound)
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
                                            Text(message.text.bound)
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
//                    .onReceive(chatModel.$count) { _ in
//                        withAnimation(.easeOut(duration: 0.5)) {
//                            scrollViewProxy.scrollTo(self.emptyScrollToString, anchor: .bottom)
//                        }
//                    }
                    
                }
                
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
        }

    private var MessageSendField: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
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

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(toUser: Binding.constant(ChatUser(id: "123", firstName: "Piyush", lastName: "Garg", image1: ProfileImage())))
            .environmentObject(ChatModel())
            .environmentObject(MainMessagesViewModel())
    }
}
