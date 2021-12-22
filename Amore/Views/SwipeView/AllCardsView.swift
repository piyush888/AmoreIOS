//
//  AllCardsView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/9/21.
//


import SwiftUI
import SDWebImageSwiftUI

struct AllCardsView: View {
    
    @State var numberOfProfilesSwiped = 0
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var reportActivityModel: ReportActivityModel
    
    @State var curSwipeStatus: LikeDislike = .none
    @State var cardSwipeDone: Bool = true
    
    @State private var safetyButton = false
    @State private var showingAlert = false
    
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
            print("Prefetched image for ", card.id as Any)
        }
    }
    
    func getCards() -> [CardProfileWithPhotos] {
        if cardProfileModel.allCardsWithPhotosDeck.count>20 {
            Array(cardProfileModel.allCardsWithPhotosDeck.suffix(20)).map{
                card in
                prefetchNextCardPhotos(card: card)
            }
            return Array(cardProfileModel.allCardsWithPhotosDeck.suffix(10))
        }
        else {
            return Array(cardProfileModel.allCardsWithPhotosDeck.suffix(cardProfileModel.allCardsWithPhotosDeck.count))
        }
    }
    
    enum LikeDislike: Int {
        case like, dislike, none, superlike
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                ZStack {
                    
                    ForEach(getCards()) { profile in
                        // Normal Card View being rendered here.
                        SingleCardView(currentSwipeStatus: cardProfileModel.allCardsWithPhotosDeck.last == profile ?
                                       $curSwipeStatus : Binding.constant(AllCardsView.LikeDislike.none),
                                       singleProfile: profile,
                                       onRemove: { removedUser in
                                            // Remove that user from our array
                                            cardProfileModel.allCardsWithPhotosDeck.removeAll { $0.id == removedUser.id }
                                            cardProfileModel.cardsDictionary.removeValue(forKey: removedUser.id ?? "")
                                            self.curSwipeStatus = .none
                                            cardProfileModel.lastSwipedCard = removedUser
                                }
                            )
                            .animation(.spring())
                            .frame(width: geometry.size.width)
                            .environmentObject(photoModel)
                            .environmentObject(cardProfileModel)
                        
                    }
                    .onChange(of: cardProfileModel.allCardsWithPhotosDeck) { _ in
                        print("Count: Cards Being Shown ", cardProfileModel.allCardsWithPhotosDeck.count)
                        self.cardSwipeDone = true
                        cardProfileModel.areMoreCardsNeeded()
                        print("Last Swiped Card: ", cardProfileModel.lastSwipedCard?.id, cardProfileModel.lastSwipeInfo)
                    }
                    
                    VStack {
                        HStack {
                            Spacer()
                            ShieldButton(safetyButton:$safetyButton,
                                         buttonWidth:30,
                                         buttonHeight: 35,
                                         fontSize:25,
                                         shieldColorList:[Color.gray, Color.purple])
                        }
                        .padding(.top,15)
                        .padding(.horizontal,15)
                        
                        
                        Spacer()
                        LikeDislikeSuperLike(curSwipeStatus: $curSwipeStatus, cardSwipeDone: $cardSwipeDone)
                            .environmentObject(cardProfileModel)
                            .padding(.bottom, 20)
                            .padding(.horizontal, 40)
                            .opacity(1.5)
                    }
                    
                }
            }
            .sheet(isPresented: $safetyButton) {
                if let profile = cardProfileModel.allCardsWithPhotosDeck.last {
                    ReportingIssuesCard(safetyButton: self.$safetyButton, profileId: profile.id.bound,
                                        showingAlert:self.$showingAlert,
                                        onRemove: { profileId in
                                            cardProfileModel.allCardsWithPhotosDeck.removeAll { $0.id == profileId }
                                            cardProfileModel.cardsDictionary.removeValue(forKey: profileId)
                        })
                }
            }
            .alert(isPresented: $showingAlert) {
                   Alert(
                       title: Text(""),
                       message: Text("Failed to report user")
                   )
               }
        }
        .padding(.horizontal)
    }
}



