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
                if cardSwipeDone {
                    cardSwipeDone = false
                    FirestoreServices.undoLikeDislikeFirestore(apiToBeUsed: "/rewindswipesingle", onFailure: {}, onSuccess: {
                        rewindedUserCard in
                        let cardProfileWithPhotos = CardProfileModel.cardProfileToCardProfileWithPhotos(card: rewindedUserCard)
                        
                        // Append rewinded user in Array
                        cardProfileModel.allCardsWithPhotosDeck.append(cardProfileWithPhotos)
                        
                        // Append rewinded user in Dict
                        if let rewindedUserId = cardProfileWithPhotos.id {
                            cardProfileModel.cardsDictionary[rewindedUserId] = cardProfileWithPhotos
                            receivedGivenEliteModel.rewindAction(swipedUserId: rewindedUserId)
                        }
                        cardSwipeDone = true
                    })
                }
            } label: {
                Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                    .resizable()
                    .frame(width:35, height:35)
                    .foregroundColor(.orange)
            }
            .disabled(!cardSwipeDone)

            Spacer()
            
            // Dislike Button
            Button {
                // If card swiping action is finished
                if cardSwipeDone {
                    cardSwipeDone = false
                    buttonSwipeStatus = AllCardsView.LikeDislike.dislike
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
                    cardSwipeDone = false
                    buttonSwipeStatus = AllCardsView.LikeDislike.superlike
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
                    cardSwipeDone = false
                    buttonSwipeStatus = AllCardsView.LikeDislike.like
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
