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
                    DeckCards(cardDecks: $cardProfileModel.allCardsWithPhotosDeck1,
                              cardWidth:geometry.size.width,
                              curSwipeStatus : $curSwipeStatus)
                            .zIndex(cardProfileModel.deck1Zndex)
                            .environmentObject(cardProfileModel)
                            .environmentObject(photoModel)
                            .onChange(of: cardProfileModel.allCardsWithPhotosDeck1) { _ in
                                print("CardPhoto: On Change on ForEach Triggered")
                            }
                    
                    DeckCards(cardDecks: $cardProfileModel.allCardsWithPhotosDeck2,
                              cardWidth:geometry.size.width,
                              curSwipeStatus : $curSwipeStatus)
                        .zIndex(cardProfileModel.deck2Zndex)
                        .environmentObject(cardProfileModel)
                        .environmentObject(photoModel)
                        .onChange(of: cardProfileModel.allCardsWithPhotosDeck2) { _ in
                            print("CardPhoto: On Change on ForEach Triggered")
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



