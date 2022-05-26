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
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    @EnvironmentObject var filterModel: FilterModel
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @EnvironmentObject var reportActivityModel: ReportActivityModel
    @EnvironmentObject var storeManager: StoreManager
    
    @State var selectedTab: TopPicksLikesView = .likesReceived
    
    func checkIfDataIsComing() {
        if (cardProfileModel.timeOutRetriesCount > 1) && (cardProfileModel.allCardsWithPhotosDeck.count == 0) {
            serviceErrorView = .serverErrorView
        }
    }
    
    func didDimiss() {
        storeManager.paymentCompleteDisplayMyAmore = false
    }
    
    var body: some View {
        
            switch serviceErrorView {
                    
                    case .allServicesAreGoodView:
                        VStack {
                            switch currentPage {
                                
                                case .messagingView:
                                    MainMessagesView()
                                    
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
                                        .environmentObject(filterModel)
                                    
                                case .filterSettingsView:
                                    FilterSettings()
                                        .environmentObject(filterModel)
                                        .environmentObject(cardProfileModel)
                                        .onChange(of: filterModel.filterData) { _ in
                                            filterModel.updateFilter()
                                        }
                                    
                                case .userSettingsView:
                                    // Load the user profile
                                    UserProfile()
                                        .environmentObject(profileModel)
                                        .environmentObject(photoModel)
                                        .environmentObject(storeManager)
                                        .sheet(isPresented: $storeManager.paymentCompleteDisplayMyAmore,
                                               onDismiss: didDimiss){
                                            PaymentComplete(subscriptionTypeId:storeManager.purchaseDataDetails.subscriptionTypeId ?? "Amore.ProductId.12M.Free.v1")
                                                .environmentObject(storeManager)
                                        }
                             
                            }
                            // Control Center
                            ControlCenter(currentPage:$currentPage)
                                .padding(.horizontal,30)
                                .padding(.top,10)
                            
                            }
//                        .onChange(of: cardProfileModel.timeOutRetriesCount, perform: { errorCount in
//                                self.checkIfDataIsComing()
//                            })
//
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
