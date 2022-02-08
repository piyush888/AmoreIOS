//
//  LikeDislikeSuperLike.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/6/21.
//

import SwiftUI

struct LikeDislikeSuperLike: View {
    
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @Binding var curSwipeStatus: AllCardsView.LikeDislike
    @Binding var cardSwipeDone: Bool
    
    var body: some View {
        
        HStack {
            
            Button {
                if cardProfileModel.lastSwipedCard != nil && cardProfileModel.lastSwipeInfo != nil {
                    cardProfileModel.allCardsWithPhotosDeck.append(cardProfileModel.lastSwipedCard!)
                    cardProfileModel.cardsDictionary[cardProfileModel.lastSwipedCard!.id!] = cardProfileModel.lastSwipedCard!
                    FirestoreServices.undoLikeDislikeFirestore(apiToBeUsed: "/rewindswipesingle", onFailure: {}, onSuccess: {}, swipedUserId: cardProfileModel.lastSwipedCard?.id, swipeInfo: cardProfileModel.lastSwipeInfo!)
                    receivedGivenEliteModel.rewindAction(swipedUserId: cardProfileModel.lastSwipedCard?.id, swipeInfo: cardProfileModel.lastSwipeInfo!)
                    cardProfileModel.lastSwipedCard = nil
                    cardProfileModel.lastSwipeInfo = nil
                }
            } label: {
                Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                    .resizable()
                    .frame(width:35, height:35)
                    .foregroundColor(.orange)
            }

            Spacer()
            
            Button {
                if cardSwipeDone {
                    curSwipeStatus = AllCardsView.LikeDislike.dislike
//                    print("Count: Button Dislike Pressed")
                    cardSwipeDone = false
//                    print("Count: card swipe done: ", cardSwipeDone)
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width:55, height:55)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .shadow(color: .white,
                            radius: 5, x: 1, y: 1)
            }
            .disabled(!cardSwipeDone)
            
            Spacer()
            
            Button {
                if cardSwipeDone {
                    curSwipeStatus = AllCardsView.LikeDislike.superlike
//                    print("Count: Button SuperLike Pressed")
                    cardSwipeDone = false
//                    print("Count: card swipe done: ", cardSwipeDone)
                }
            } label: {
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .frame(width:40, height:40)
                    .foregroundColor(Color("gold-star"))
                    .shadow(color: .white,
                            radius: 1, x: 1, y: 1)
            }

            Spacer()
            
            Button {
                if cardSwipeDone {
                    curSwipeStatus = AllCardsView.LikeDislike.like
//                    print("Count: Button Like Pressed")
                    cardSwipeDone = false
//                    print("Count: card swipe done: ", cardSwipeDone)
                }
            } label: {
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .frame(width:55, height:55)
                    .foregroundColor(.pink)
                    .padding(.horizontal)
                    .shadow(color: .white,
                            radius: 5, x: 1, y: 1)
            }
            .disabled(!cardSwipeDone)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "bolt.circle.fill")
                    .resizable()
                    .frame(width:35, height:35)
                    .foregroundColor(.blue)
                    .shadow(color: .blue,
                            radius: 0.1, x: 1, y: 1)
            }
                
        }
    }
}

struct LikeDislikeSuperLike_Previews: PreviewProvider {
    static var previews: some View {
        LikeDislikeSuperLike(curSwipeStatus: Binding.constant(AllCardsView.LikeDislike.none), cardSwipeDone: Binding.constant(true))
    }
}
