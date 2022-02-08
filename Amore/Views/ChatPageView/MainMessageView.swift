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
//    @StateObject var mainMessagesModel = MainMessagesViewModel()
//    @StateObject var chatModel = ChatModel()
    @EnvironmentObject var chatModel: ChatModel
    @EnvironmentObject var mainMessagesModel: MainMessagesViewModel

    var body: some View {
        NavigationView {

            VStack {
                customNavBar(shouldShowLogOutOptions: $shouldShowLogOutOptions)
                    .environmentObject(mainMessagesModel)
                AllConversationsView(navigateToChatView: $navigateToChatView)
                    .environmentObject(chatModel)
                    .environmentObject(mainMessagesModel)
            }
            .navigationBarHidden(true)
        }
    }

}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .environmentObject(ChatModel())
            .environmentObject(MainMessagesViewModel())
    }
}


