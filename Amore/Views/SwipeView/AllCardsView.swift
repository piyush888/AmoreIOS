//
//  AllCardsView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/9/21.
//


import SwiftUI

struct AllCardsView: View {
    
    @State var numberOfProfilesSwiped = 0
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @State var curSwipeStatus: LikeDislike = .none
    
    func getCards() -> [CardProfileWithPhotos] {
        if cardProfileModel.allCardsWithPhotosDeck.count>4 {
            return Array(cardProfileModel.allCardsWithPhotosDeck.suffix(4))
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
//                            cardProfileModel.allCardsWithPhotosDeck.removeAll { $0.id == removedUser.id }
                            cardProfileModel.allCardsWithPhotosDeck.removeLast()
                                            self.curSwipeStatus = .none
                                        }
                        )
                        .animation(.spring())
                        .frame(width: geometry.size.width)
                        .environmentObject(photoModel)
                        .environmentObject(cardProfileModel)

                    }
                    .onChange(of: cardProfileModel.allCardsWithPhotosDeck) { _ in
                        print("CardPhoto: On Change on ForEach Triggered First Deck")
                    }
                    
                    VStack {
                        Spacer()
                        LikeDislikeSuperLike(curSwipeStatus: $curSwipeStatus)
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



