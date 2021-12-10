//
//  HomeView.swift
//  Amore
//
//  Created by Piyush Garg on 28/09/21.
//

import SwiftUI

struct HomeView: View {
    
    @State var serviceErrorView: ErrorView = .allServicesAreGoodView
    @State var currentPage: ViewTypes = .likesTopPicksView
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var streamModel: StreamViewModel
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    @EnvironmentObject var filterAndLocationModel: FilterAndLocationModel
//    @EnvironmentObject var locationModel: LocationModel
    @EnvironmentObject var cardProfileModel: CardProfileModel
    
    func checkIfDataIsComing() {
        if (cardProfileModel.timeOutRetriesCount > 9) && (cardProfileModel.allCardsWithPhotosDeck.count == 0) {
            serviceErrorView = .serverErrorView
        }
    }
    
    var body: some View {
        
            switch serviceErrorView {
                    
                    case .allServicesAreGoodView:
                        VStack {
                            switch currentPage {
                                
                                case .messagingView:
                                    ChannelView()
                                        .environmentObject(streamModel)
                                    
                                case .likesTopPicksView:
                                LikesTopPicksHome()
                                        .environmentObject(cardProfileModel)
                                    
                                case .swipeView:
                                    AllCardsView()
                                        .environmentObject(adminAuthenticationModel)
                                        .environmentObject(photoModel)
                                        .environmentObject(cardProfileModel)
                                        
                                case .filterSettingsView:
                                    FilterSettings()
                                        .environmentObject(filterAndLocationModel)
                                        .onChange(of: filterAndLocationModel.filterAndLocationData) { _ in
                                            print("On change for filter triggered")
                                            filterAndLocationModel.getLocationOnce()
                                            filterAndLocationModel.updateFilterAndLocation()
                                        }
                                    
                                case .userSettingsView:
                                    UserProfile()
                                        .environmentObject(profileModel)
                                        .environmentObject(photoModel)
                            }
                            
                            // Control Center
                            ControlCenter(currentPage:$currentPage)
                                .padding(.horizontal,30)
                                .padding(.top,10)
                            
                            }.onChange(of: cardProfileModel.timeOutRetriesCount, perform: { errorCount in
                                self.checkIfDataIsComing()
                            })
                        
                    case .serverErrorView:
                        ServerErrorView()
                }
        }
    }


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
