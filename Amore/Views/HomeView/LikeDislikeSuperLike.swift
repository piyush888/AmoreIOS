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
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var chatModel: ChatModel
    @EnvironmentObject var mainMessagesModel: MainMessagesViewModel
    @Binding var buttonSwipeStatus: AllCardsView.LikeDislike
    @Binding var cardSwipeDone: Bool
    @Binding var allcardsActiveSheet: AllCardsActiveSheet?
    
    var body: some View {
        
        HStack {
            // Rewind Button
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
            
            // Dislike Button
            Button {
                if cardSwipeDone {
                    buttonSwipeStatus = AllCardsView.LikeDislike.dislike
                    cardSwipeDone = false
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
            
            // Superlike Button
            Button {
                if cardSwipeDone {
                    buttonSwipeStatus = AllCardsView.LikeDislike.superlike
                    cardSwipeDone = false
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
            
            // Like Button
            Button {
                if cardSwipeDone {
                    buttonSwipeStatus = AllCardsView.LikeDislike.like
                    cardSwipeDone = false
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
            
            // DM Button
            Button {
                allcardsActiveSheet = .directMessageSheet
            } label: {
                Image(systemName: "message.circle.fill")
                    .resizable()
                    .frame(width:35, height:35)
                    .foregroundColor(Color(hex:0xFA86C4))
                    .shadow(color: .blue,
                            radius: 0.1, x: 1, y: 1)
            }
                
        }
    }
}

struct LikeDislikeSuperLike_Previews: PreviewProvider {
    static var previews: some View {
        LikeDislikeSuperLike(buttonSwipeStatus: Binding.constant(AllCardsView.LikeDislike.none),
                             cardSwipeDone: Binding.constant(true),
                             allcardsActiveSheet: Binding.constant(AllCardsActiveSheet.directMessageSheet))
    }
}
