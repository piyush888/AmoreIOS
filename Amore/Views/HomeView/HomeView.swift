//
//  HomeView.swift
//  Amore
//
//  Created by Piyush Garg on 28/09/21.
//

import SwiftUI

struct HomeView: View {
    
    @State var currentPage: ViewTypes = .swipeView
    
    var body: some View {
        VStack {
            
            // Control Center
            ControlCenter(currentPage:$currentPage)
                .padding()
            
            
            switch currentPage {
                
                case .messagingView:
                    MessageView()
                    
                case .likesTopPicksView:
                    LikesTopPicksHome()
                    
                case .swipeView:
                    AllCardsView()
                    LikeDislikeSuperLike()
                    .padding()
                    
                case .filterSettingsView:
                    FilterSettings()
                    
                case .userSettingsView:
                    UserSettings()
            }
                        
        }.navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
