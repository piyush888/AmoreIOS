//
//  HomeView.swift
//  Amore
//
//  Created by Piyush Garg on 28/09/21.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @State var serviceErrorView: ErrorView = .allServicesAreGoodView
    @State var currentPage: ViewTypes = .swipeView
    
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var streamModel: StreamViewModel
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    @EnvironmentObject var filterModel: FilterModel
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @EnvironmentObject var reportActivityModel: ReportActivityModel
    
    @State var selectedTab: TopPicksLikesView = .likesReceived
    
    func checkIfDataIsComing() {
        if (cardProfileModel.timeOutRetriesCount > 4) && (cardProfileModel.allCardsWithPhotosDeck.count == 0) {
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
                                LikesTopPicksHome(selectedTab:$selectedTab)
                                        .environmentObject(cardProfileModel)
                                        .environmentObject(receivedGivenEliteModel)
                                        
                                    
                                case .swipeView:
                                    AllCardsView()
                                        .environmentObject(adminAuthenticationModel)
                                        .environmentObject(photoModel)
                                        .environmentObject(cardProfileModel)
                                        .environmentObject(reportActivityModel)
                                        .environmentObject(profileModel)
                                
                                        
                                case .filterSettingsView:
                                    FilterSettings()
                                        .environmentObject(filterModel)
                                        .onChange(of: filterModel.filterData) { _ in
                                            print("On change for filter triggered")
                                            filterModel.updateFilter()
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
                    .environmentObject(photoModel)
                }
        }
    }


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
