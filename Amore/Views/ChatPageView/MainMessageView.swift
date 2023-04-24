//
//  MainMessageView.swift
//  Amore
//
//  Created by Piyush Garg on 03/02/22.
//

import SwiftUI

struct MainMessagesView: View {
    
    init(currentPage: Binding<ViewTypes>) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
        UINavigationBar.appearance().standardAppearance = appearance
        _currentPage = currentPage
    }
    
    @State var shouldShowLogOutOptions = false
    @State var navigateToChatView: Bool = false
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var mainMessagesModel: MainMessagesViewModel
    @EnvironmentObject var tabModel: TabModel
    @Binding var currentPage: ViewTypes
    
    var body: some View {
        NavigationView {

            VStack {
                AllConversationsView(navigateToChatView: $navigateToChatView,
                                     currentPage:$currentPage)
                    .environmentObject(chatViewModel)
                    .environmentObject(mainMessagesModel)
                    .environmentObject(tabModel)
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView(currentPage:Binding.constant(ViewTypes.messagingView))
    }
}


