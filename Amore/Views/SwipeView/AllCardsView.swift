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
    
    
    enum LikeDislike: Int {
        case like, dislike, none
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(cardProfileModel.allCardsWithPhotos) { profile in
                        /// Using the pattern-match operator ~=, we can determine if our
                        /// user.id falls within the range of 6...9

                        // Normal Card View being rendered here.
                        SingleCardView(currentSwipeStatus: cardProfileModel.allCardsWithPhotos.last == profile ?
                                       $curSwipeStatus : Binding.constant(LikeDislike.none),
                                       singleProfile: Binding.constant(profile),
                                       onRemove: { removedUser in
                                            // Remove that user from our array
                            cardProfileModel.allCardsWithPhotos.removeAll { $0.id == removedUser.id }
                                            self.curSwipeStatus = .none
                                        }
                        )
                        .animation(.spring())
                        .frame(width: geometry.size.width)
                        .environmentObject(photoModel)

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



