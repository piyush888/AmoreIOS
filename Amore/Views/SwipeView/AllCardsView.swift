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
    @State var curSwipeStatus: LikeDislike = .none
    @State var cardSwipeDone: Bool = true
    
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
    
    func showNames(card: CardProfileWithPhotos) {
        print("Name: ", card.firstName as Any)
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
            return [CardProfileWithPhotos]()
        }
        
    }
    
    enum LikeDislike: Int {
        case like, dislike, none
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
//                                          cardProfileModel.allCardsWithPhotosDeck.removeLast()
                                            cardProfileModel.cardsDictionary.removeValue(forKey: removedUser.id ?? "")
                                            self.curSwipeStatus = .none
                                        }
                        )
                        .animation(.spring())
                        .frame(width: geometry.size.width)
                        .environmentObject(photoModel)
                        .environmentObject(cardProfileModel)

                    }
                    .onChange(of: cardProfileModel.allCardsWithPhotosDeck) { _ in
                        print("Count: Cards Being Shown ", cardProfileModel.allCardsWithPhotosDeck.count)
//                        Array(cardProfileModel.allCardsWithPhotosDeck.suffix(10)).map{
//                            card in
//                            showNames(card: card)
//                        }
                        self.cardSwipeDone = true
//                        print("Count: card swipe done: ", cardSwipeDone)
//                        print("Name: _______________________________")
                    }
                    
                    VStack {
                        Spacer()
                        LikeDislikeSuperLike(curSwipeStatus: $curSwipeStatus, cardSwipeDone: $cardSwipeDone)
                            .padding(.bottom, 20)
                            .padding(.horizontal, 40)
                            .opacity(1.5)
                    }
                    
                }
            }
        }
        .padding(.horizontal)
    }
}



