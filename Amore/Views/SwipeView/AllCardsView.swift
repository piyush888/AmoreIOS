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
    @State private var safetyButton = false
    @State private var showingAlert = false
    @State var allcardsActiveSheet: AllCardsActiveSheet?
    
    @State private var cardIncrementCount: Int = 0
    
    func prefetchNextCardPhotos(card: CardProfileWithPhotos) {
        var urls: [URL] = []
        for url in [card.image1?.imageURL, card.image2?.imageURL, card.image3?.imageURL, card.image4?.imageURL, card.image5?.imageURL, card.image6?.imageURL] {
            if url != nil {
                urls.append(url!)
            }
        }
        SDWebImagePrefetcher.shared.prefetchURLs(urls) { completed, total in
            // Progress Block
        } completed: { completed, skipped in
            // On Complete Block
        }
    }
    
    // Cards Throttler in Swipe View
    /// Controls the number of cards currently in users swipe view
    func getCards() -> [CardProfileWithPhotos] {
        // Returns only 2 cards in first load and after the first load it returns 5 cards
        /// You want the first load to be faster so that Swipe loads quickly
        return Array(cardProfileModel.allCardsWithPhotosDeck.suffix(3+self.cardIncrementCount))
    }
    
    enum LikeDislike: Int {
        case like, dislike, none, superlike
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                
                // Show all cards that user can swipe
                ForEach(getCards()) { profile in
                    DeckCards(cardSwipeDone: $cardSwipeDone, allcardsActiveSheet: $allcardsActiveSheet, singleProfile: profile, onRemove: { removedUser in
                        // Remove that user from Array of CardProfileWithPhotos O(n)
                        cardProfileModel.allCardsWithPhotosDeck.removeAll { $0.id == removedUser.id }
                        
                        // Remove that user from Dictionary: [ID: CardProfileWithPhotos] O(1)
                        /// Commenting the removal of cards from cards dictionary. This fixed the cause of rewind button not working
                        /// cardProfileModel.cardsDictionary.removeValue(forKey: removedUser.id ?? "")
                        
                        // Once a user card is swipped from the deck you would want to reset the swipeStatus to none
                        self.buttonSwipeStatus = .none
                        
                        // Returns only 2 cards in first load and after the first swipe throttler returns 5 cards
                        /// You want the first load to be faster so that Swipe loads quickly
                        self.cardIncrementCount = 2
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
                                                    // Remove from Dict
                                                    cardProfileModel.cardsDictionary.removeValue(forKey: profileId)
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
                print("Change in no. of cards, current count: \(cardProfileModel.allCardsWithPhotosDeck.count)")
                print("Change: Card Deck:")
                getCards().map { card in
                    print("Change: Card in Deck: \(card.id)")
                }
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
