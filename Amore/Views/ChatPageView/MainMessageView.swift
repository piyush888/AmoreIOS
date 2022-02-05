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
    @EnvironmentObject var mainMessagesModel: MainMessagesViewModel
    @EnvironmentObject var chatModel: ChatModel

    var body: some View {
        NavigationView {

            VStack {
                customNavBar(shouldShowLogOutOptions: $shouldShowLogOutOptions)
                    .environmentObject(mainMessagesModel)
                MessagesView(navigateToChatView: $navigateToChatView)
                    .environmentObject(chatModel)
            }
            .navigationBarHidden(true)
        }
    }

}

struct MainMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .environmentObject(MainMessagesViewModel())
    }
}


