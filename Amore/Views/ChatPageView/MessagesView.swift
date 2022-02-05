//
//  MessagesView.swift
//  Amore
//
//  Created by Piyush Garg on 04/02/22.
//

import SwiftUI

struct MessagesView: View {
    
    @Binding var navigateToChatView: Bool
    @EnvironmentObject var chatModel: ChatModel
    
    var body: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    NavigationLink(isActive: $navigateToChatView) {
                        ChatLogView(toUser: Binding.constant(ChatUser(id: "123", firstName: "Piyush", lastName: "Garg", image1: ProfileImage())))
                            .environmentObject(chatModel)
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 32))
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color(.label), lineWidth: 1)
                                )


                            VStack(alignment: .leading) {
                                Text("Username")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Message sent to user")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                            }
                            Spacer()

                            Text("22d")
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)

            }.padding(.bottom, 50)
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(navigateToChatView: Binding.constant(false))
    }
}
