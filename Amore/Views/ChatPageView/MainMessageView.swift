//
//  MainMessageView.swift
//  Amore
//
//  Created by Piyush Garg on 03/02/22.
//

import SwiftUI

struct MainMessagesView: View {

    @State var shouldShowLogOutOptions = false
    @State var navigateToChatView: Bool = false
    @StateObject var mainMessagesModel = MainMessagesViewModel()
    @StateObject var chatModel = ChatModel()

    var body: some View {
        NavigationView {

            VStack {
                AllConversationsView(navigateToChatView: $navigateToChatView)
                    .environmentObject(chatModel)
                    .environmentObject(mainMessagesModel)
            }
            .navigationTitle("Messages")
//            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }

}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}

