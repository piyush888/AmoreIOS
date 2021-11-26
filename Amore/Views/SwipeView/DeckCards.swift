//
//  DeckCards.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/26/21.
//

import SwiftUI

struct DeckCards: View {
    
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var photoModel: PhotoModel
    
    @Binding var cardDecks: [CardProfileWithPhotos]
    @State var cardWidth: CGFloat
    @Binding var curSwipeStatus: AllCardsView.LikeDislike
    
    
    var body: some View {
        
        ForEach(self.cardDecks) { profile in
            // Normal Card View being rendered here.
            SingleCardView(currentSwipeStatus: self.cardDecks.last == profile ?
                           $curSwipeStatus : Binding.constant(AllCardsView.LikeDislike.none),
                           singleProfile: profile,
                           onRemove: { removedUser in
                                // Remove that user from our array
                self.cardDecks.removeAll { $0.id == removedUser.id }
                                self.curSwipeStatus = .none
                            }
            )
            .animation(.spring())
            .frame(width: cardWidth)
            .environmentObject(photoModel)
            .environmentObject(cardProfileModel)

        }
        
        
    }
}


