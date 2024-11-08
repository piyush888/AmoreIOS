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
    @EnvironmentObject var chatViewModel: ChatViewModel
    @StateObject var mainMessagesModel = MainMessagesViewModel()
    
    @State var selectedTab: TopPicksLikesView = .likesReceived
    @State var filtersChanged: Bool = false
    
    
    func didDimiss() {
        storeManager.paymentCompleteDisplayMyAmore = false
        storeManager.displayProductModalWindow = false
    }
    
    var body: some View {
        
            switch serviceErrorView {
                    
                    case .allServicesAreGoodView:
                        VStack {
                            VStack {
                                switch currentPage {
                                
                                case .messagingView:
                                    MainMessagesView(currentPage:$currentPage)
                                        .environmentObject(chatViewModel)
                                        .environmentObject(mainMessagesModel)
                                        .environmentObject(tabModel)
                                    
                                case .likesTopPicksView:
                                    LikesTopPicksHome(selectedTab:$selectedTab)
                                        .environmentObject(cardProfileModel)
                                        .environmentObject(receivedGivenEliteModel)
                                        .environmentObject(profileModel)
                                        .environmentObject(storeManager)
                                        
                                        
                                case .swipeView:
                                    if profileModel.editUserProfile.discoveryStatus.boundBool {
                                        if cardProfileModel.allCardsWithPhotosDeck.count==0 {
                                            VStack {
                                                Spacer()
//                                                Text("Fetching profiles, consider expanding filters for more profiles")
                                                ProgressView()
                                                Spacer()
                                            }
                                        } else {
                                            AllCardsView(allCardsWithPhotosDeck:cardProfileModel.allCardsWithPhotosDeck,
                                                         currentPage:$currentPage)
                                                .environmentObject(photoModel)
                                                .environmentObject(cardProfileModel)
                                                .environmentObject(reportActivityModel)
                                                .environmentObject(profileModel)
                                                .environmentObject(filterModel)
                                                .environmentObject(storeManager)
                                                .environmentObject(chatViewModel)
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
                                    }
                                    else {
                                        DiscoveryDisabled()
                                            .environmentObject(profileModel)
                                    }
                                        
                                    
                                case .filterSettingsView:
                                    FilterSettings()
                                        .environmentObject(filterModel)
                                        .environmentObject(cardProfileModel)
                                        .onDisappear {
                                            // Update cards in the deck when view switches to Swipe View
                                            filtersChanged = filterModel.updateFilter()
                                        }
                                        
                                    
                                case .userSettingsView:
                                    
                                    // Load the user profile
                                    UserProfile()
                                        .environmentObject(profileModel)
                                        .environmentObject(photoModel)
                                        .environmentObject(storeManager)
                                        .environmentObject(adminAuthenticationModel)
                                        .environmentObject(tabModel)
                                        .environmentObject(mainMessagesModel)
                                }
                            }
                            
                            // Tab View
                            if !tabModel.showDetail {
                            ControlCenter(currentPage:$currentPage)
//                                .offset(y: tabModel.showDetail ? 200 : 0)
                            }
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                        .sheet(isPresented: $storeManager.paymentCompleteDisplayMyAmore,
                               onDismiss: didDimiss){
                            PaymentComplete(subscriptionTypeId:storeManager.purchaseDataDetails.subscriptionTypeId ?? "Amore.ProductId.12M.Free.v3",
                                            currentPage:$currentPage)
                                .environmentObject(storeManager)
                        }
                
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
            .environmentObject(ChatViewModel())
    }
}
