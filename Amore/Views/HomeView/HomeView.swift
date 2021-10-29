//
//  HomeView.swift
//  Amore
//
//  Created by Piyush Garg on 28/09/21.
//

import SwiftUI

struct HomeView: View {
    
    @State var currentPage: ViewTypes = .userSettingsView
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var streamModel: StreamViewModel
    @EnvironmentObject var photoModel: PhotoModel
    
    
    var body: some View {
        
        
        
            VStack {
            
                
                switch currentPage {
                    
                    case .messagingView:
                        ChannelView()
                            .environmentObject(streamModel)
                        
                    case .likesTopPicksView:
                        LikesTopPicksHome()
                        
                    case .swipeView:
                        AllCardsView()
                        
                    case .filterSettingsView:
                        FilterSettings()
                        
                    case .userSettingsView:
                        UserProfile()
                            .environmentObject(profileModel)
                            .environmentObject(photoModel)
                }
                
                // Control Center
                ControlCenter(currentPage:$currentPage)
                    .padding(.horizontal,30)
                    .padding(.top,10)
                    
                
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
