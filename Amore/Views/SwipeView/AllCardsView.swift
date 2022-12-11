//
//  AllCardsView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/9/21.
//


import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct AllCardsView: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var reportActivityModel: ReportActivityModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @EnvironmentObject var filterModel: FilterModel
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var mainMessagesModel: MainMessagesViewModel
    
    
    @State var buttonSwipeStatus: LikeDislike = .none
    // Used to track if the swipe given task is complete before allowing user to swipe the next card in deck by disabling the buttons
    @State var cardSwipeDone: Bool = true
    @State private var safetyButton: Bool = false
    @State private var showingAlert: Bool = false
    @State var allcardsActiveSheet: AllCardsActiveSheet?
    @State var allCardsWithPhotosDeck: [CardProfileWithPhotos]
    
    
    @StateObject private var weakCardProfileModel: WeakCardProfileModel
    
    init(allCardsWithPhotosDeck:[CardProfileWithPhotos]) {
        self.buttonSwipeStatus = .none
        self.cardSwipeDone = true
        self.safetyButton = false
        self.showingAlert = false
        self.allcardsActiveSheet = .none
        self.allCardsWithPhotosDeck = allCardsWithPhotosDeck
        // When the view load first time you only want the loading of view to be quick hence you only load 3 cards
        /// In the first swipe we update the increment number of cards to be displayed by setting cardIncrementCount=2
        /// In total there are 5 cards displayed at any time
        _weakCardProfileModel = StateObject(wrappedValue: WeakCardProfileModel(cardsInDeck: allCardsWithPhotosDeck,
                                                    cardIncrementCount:0,
                                                    initializeSwipeViewWithCards:3))
    }
    
    enum LikeDislike: Int {
        case like, dislike, none, superlike
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                
                // Swipe View Cards Display
                /// First Load: 2 cards are loaded
                /// After first Swipe: 5 cards are loaded in the view at any time
                /// For every swipe a card is prefetched
                /// Show all cards that user can swipe
                ForEach(weakCardProfileModel.cardsInSwipeViewDisplay ?? []) { profile in
                    DeckCards(cardSwipeDone: $cardSwipeDone, allcardsActiveSheet: $allcardsActiveSheet, singleProfile: profile, onRemove: { removedUser in
                        // Remove that user from Array of CardProfileWithPhotos O(n)
                        cardProfileModel.allCardsWithPhotosDeck.removeAll { $0.id == removedUser.id }
                        
                        // Once a user card is swipped from the deck you would want to reset the swipeStatus to none
                        self.buttonSwipeStatus = .none
                        
                        // Returns only 2 cards in first load and after the first swipe throttler returns 5 cards
                        /// You want the first load to be faster so that Swipe loads quickly
                        weakCardProfileModel.cardIncrementCount = 2
                            
                        // Once user has seen a profile remove the cached images and NSData for image from phone
                        weakCardProfileModel.deleteCardImages(singleProfile: profile)
                        
                        // Prefetch the next photo in the deck
                         weakCardProfileModel.prefetchNextCardPhotos()
                    })
                    .animation(.spring())
                    .frame(width: geometry.size.width)
                    .environmentObject(photoModel)
                    .environmentObject(cardProfileModel)
                    .environmentObject(profileModel)
                    .environmentObject(receivedGivenEliteModel)
                    .environmentObject(filterModel)
                    .environmentObject(storeManager)
                }
                
                // Buttons and other interaction on top of cards
                VStack {
                    // Boost and Report Buttons
                    HStack {
                        ButtonIcon(allcardsActiveSheet:$allcardsActiveSheet,
                                     buttonWidth:30,
                                     buttonHeight: 35,
                                     fontSize:25,
                                     colorList: [Color(hex: 0x8f94fb)],
                                     viewToBeAssigned:.boostProfileSheet,
                                     iconName:"bolt.circle.fill")
                        
                        Spacer()
                        
                        ButtonIcon(allcardsActiveSheet:$allcardsActiveSheet,
                                     buttonWidth:30,
                                     buttonHeight: 35,
                                     fontSize:25,
                                     colorList:[Color.gray, Color.purple],
                                     viewToBeAssigned:.reportProfileSheet,
                                     iconName:"shield.fill")
                    }
                    .padding(.top,15)
                    .padding(.horizontal,15)
                    
                    
                    Spacer()
                    
                }
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .center)
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .center)
            .sheet(item: $allcardsActiveSheet) { item in
                
                switch item {
                    case .reportProfileSheet:
                        if let profile = cardProfileModel.allCardsWithPhotosDeck.last {
                            ReportingIssuesCard(allcardsActiveSheet: $allcardsActiveSheet,
                                                profileId: profile.id.bound,
                                                showingAlert:self.$showingAlert,
                                                onRemove: { profileId in
                                                    // Remove from Array
                                                    cardProfileModel.allCardsWithPhotosDeck.removeAll { $0.id == profileId }
                                                }
                                            )
                        }
                   
                    case .boostProfileSheet:
                        BoostUserProfile(allcardsActiveSheet:$allcardsActiveSheet)
                            .environmentObject(profileModel)
                            .environmentObject(photoModel)
                    
                    case .directMessageSheet:
                        if let profile = cardProfileModel.allCardsWithPhotosDeck.last {
                            DirectMessageCardView(
                                fromUser: ChatUser(id: Auth.auth().currentUser?.uid, firstName: profileModel.editUserProfile.firstName, lastName: profileModel.editUserProfile.lastName, image1: profileModel.editUserProfile.image1),
                                toUser: ChatUser(id: profile.id, firstName: profile.firstName, lastName: profile.lastName, image1: profile.image1),
                                allcardsActiveSheet: $allcardsActiveSheet,
                                buttonSwipeStatus: $buttonSwipeStatus)
                            .environmentObject(chatViewModel)
                            .environmentObject(storeManager)
                        }
                    
                    case .buyMoreSuperLikesSheet:
                        BuyMoreSuperLikesSheet(allcardsActiveSheet:$allcardsActiveSheet)
                            .environmentObject(storeManager)
                    
                    case .buyMoreRewindsSheet:
                        BuyMoreRewinds(allcardsActiveSheet:$allcardsActiveSheet)
                        .environmentObject(storeManager)
                }
                
            }
            .alert(isPresented: $showingAlert) {
                   Alert(
                       title: Text(""),
                       message: Text("Failed to report user")
                   )
            }
            .onChange(of: cardProfileModel.allCardsWithPhotosDeck.count) { newValue in
                // On Change responssible for listening any addition or deletion of cards from the deck
                /// Once this onchange listens to changes it updates the Swipe View by updating the parameters of the WeakCardProfileModel
                print("Change in no. of cards, current count: \(cardProfileModel.allCardsWithPhotosDeck.count)")
                self.weakCardProfileModel.cardsInDeck = cardProfileModel.allCardsWithPhotosDeck
                self.weakCardProfileModel.getCardsToDisplay()
            }
        }
    }
}


enum AllCardsActiveSheet: Identifiable {
    case reportProfileSheet, boostProfileSheet, directMessageSheet, buyMoreSuperLikesSheet, buyMoreRewindsSheet
    var id: Int {
        hashValue
    }
}
