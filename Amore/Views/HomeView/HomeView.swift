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
    @StateObject var tabModel = TabModel()
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    @EnvironmentObject var filterModel: FilterModel
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @EnvironmentObject var reportActivityModel: ReportActivityModel
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var chatModel: ChatModel
    @StateObject var mainMessagesModel = MainMessagesViewModel()
    
    @State var selectedTab: TopPicksLikesView = .likesReceived
    @State var filtersChanged: Bool = false
    
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
                            VStack {
                                switch currentPage {
                                
                                case .messagingView:
                                    MainMessagesView()
                                        .environmentObject(chatModel)
                                        .environmentObject(mainMessagesModel)
                                        .environmentObject(tabModel)
                                        
                                case .likesTopPicksView:
                                    LikesTopPicksHome(selectedTab:$selectedTab)
                                        .environmentObject(cardProfileModel)
                                        .environmentObject(receivedGivenEliteModel)
                                        
                                        
                                case .swipeView:
                                    if profileModel.editUserProfile.discoveryStatus.boundBool {
                                        AllCardsView()
                                            .environmentObject(photoModel)
                                            .environmentObject(cardProfileModel)
                                            .environmentObject(reportActivityModel)
                                            .environmentObject(profileModel)
                                            .environmentObject(filterModel)
                                            .environmentObject(storeManager)
                                            .environmentObject(chatModel)
                                            .environmentObject(mainMessagesModel)
                                            .onAppear {
                                                if filtersChanged {
                                                    /// If change in filters is detected when switching to this view
                                                    /// Flush the existing deck, but keep the top 5 cards
                                                    /// Fetch new profiles, with new filters
                                                    cardProfileModel.resetDeck()
                                                    cardProfileModel.fetchProfile(filterData: filterModel.filterData)
                                                    filtersChanged = false
                                                }
                                            }
                                    }
                                    else {
                                        DiscoveryDisabled()
                                            .environmentObject(profileModel)
                                    }
                                        
                                    
                                case .filterSettingsView:
                                    FilterSettings()
                                        .environmentObject(filterModel)
                                        .environmentObject(cardProfileModel)
                                        .onChange(of: filterModel.filterData) { _ in
                                            filterModel.updateFilter()
                                            // Update cards in the deck when view switches to Swipe View
                                            filtersChanged = true
                                        }
                                        
                                    
                                case .userSettingsView:
                                    
                                    // Load the user profile
                                    UserProfile()
                                        .environmentObject(profileModel)
                                        .environmentObject(photoModel)
                                        .environmentObject(storeManager)
                                        .environmentObject(adminAuthenticationModel)
                                        .sheet(isPresented: $storeManager.paymentCompleteDisplayMyAmore,
                                               onDismiss: didDimiss){
                                            PaymentComplete(subscriptionTypeId:storeManager.purchaseDataDetails.subscriptionTypeId ?? "Amore.ProductId.12M.Free.v1")
                                                .environmentObject(storeManager)
                                        }
                                }
                            }
                            
                            // Tab View
                            if !tabModel.showDetail {
                            ControlCenter(currentPage:$currentPage)
//                                .offset(y: tabModel.showDetail ? 200 : 0)
                            }
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                
                    case .serverErrorView:
                        ServerErrorView()
                    .environmentObject(photoModel)
                }
        }
    }


struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            commonPreview
                .previewDisplayName("iPhone 13 Pro Max")
                .previewDevice("iPhone 13 Pro Max")
               
            commonPreview
                .previewDisplayName("iPhone 13 Mini")
                .previewDevice("iPhone 13 Mini")
               
            commonPreview
                .previewDisplayName("iPhone 12 Mini")
                .previewDevice("iPhone 12 Mini")
               
            commonPreview
                .previewDisplayName("iPhone 12 Pro")
                .previewDevice("iPhone 12 Pro")
                
            commonPreview
                .previewDisplayName("iPhone 11")
                .previewDevice("iPhone 11")
        }
    }
    
    static var commonPreview: some View {
        HomeView()
            .environmentObject(ProfileViewModel())
            .environmentObject(PhotoModel())
            .environmentObject(AdminAuthenticationViewModel())
            .environmentObject(FilterModel())
            .environmentObject(CardProfileModel())
            .environmentObject(ReceivedGivenEliteModel())
            .environmentObject(ReportActivityModel())
            .environmentObject(StoreManager())
            .environmentObject(ChatModel())
    }
}
