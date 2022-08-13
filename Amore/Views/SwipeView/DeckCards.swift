////
////  DeckCards.swift
////  Amore
////
////  Created by Kshitiz Sharma on 11/26/21.
////

import SwiftUI
import CoreLocation

struct DeckCards: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @EnvironmentObject var filterModel: FilterModel
    
    @Binding var cardSwipeDone: Bool
    
    @State var singleProfile: CardProfileWithPhotos
    @State var translation: CGSize = .zero
    @GestureState var dragOffset: CGSize = .zero
    
    @State var dragSwipeStatus: AllCardsView.LikeDislike = .none
    
    var onRemove: (_ user: CardProfileWithPhotos) -> Void
    
    var thresholdPercentage: CGFloat = 0.15 // when the user has draged 50% the width of the screen in either direction
    
    
    /// What percentage of our own width have we swipped
    /// - Parameters:
    ///   - geometry: The geometry
    ///   - gesture: The current gesture translation value
    func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    // O(1)
    func getProfile() -> Binding<CardProfileWithPhotos> {
        return Binding {
            cardProfileModel.cardsDictionary[singleProfile.id!] ?? CardProfileWithPhotos()
        } set: { newCard in
            cardProfileModel.cardsDictionary[singleProfile.id!] = newCard
        }
    }
    
    func saveLikeSuperlikeDislike(swipeInfo:AllCardsView.LikeDislike, onSuccess: @escaping () -> Void) {
        
        let timeDelay = swipeInfo == .superlike ? 1.5 : 0.5
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeDelay, execute: {
            FirestoreServices.storeLikesDislikes(apiToBeUsed: "/storelikesdislikes", onFailure: {
                return
            }, onSuccess: {
                onSuccess()
                receivedGivenEliteModel.addProfileToArrayFromSwipeView(profileCard: singleProfile, swipeInfo: swipeInfo)
                self.onRemove(self.singleProfile)
                self.cardSwipeDone = true
                cardProfileModel.areMoreCardsNeeded(filterData:filterModel.filterData)
            }, swipedUserId: self.singleProfile.id, swipeInfo: swipeInfo)
        })
    }
    
    func checkSwipeGesture(geometry:GeometryProxy, value: DragGesture.Value) {
        if (self.getGesturePercentage(geometry, from: value)) >= self.thresholdPercentage {
                self.dragSwipeStatus = .like
            } else if self.getGesturePercentage(geometry, from: value) <= -self.thresholdPercentage {
                self.dragSwipeStatus = .dislike
            } else {
                self.dragSwipeStatus = .none
            }
        
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
            
                ChildCardView(singleProfile: getProfile(),
                              testing:false)
                .animation(.interactiveSpring())
                .offset(x: self.translation.width + self.dragOffset.width, y: 0)
                .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 5), anchor: .bottom)
                // Dragging from UI
                .gesture(
                    DragGesture()
                        .updating($dragOffset, body: { (value, state, transaction) in
                            state = value.translation
                            DispatchQueue.main.async {
                                self.checkSwipeGesture(geometry:geometry,value:value)
                            }
                        })
                        .onEnded { value in
                            // determine snap distance > 0.5 aka half the width of the screen
                            let cardGesturePct = self.getGesturePercentage(geometry, from: value)
                            if abs(cardGesturePct) > self.thresholdPercentage {
                                self.saveLikeSuperlikeDislike(swipeInfo: self.dragSwipeStatus) {}
                                withAnimation {
                                    // For smoother swipe of the card
                                    self.translation = cardGesturePct < 0 ? CGSize(width: -500, height: 0) : CGSize(width: 500, height: 0)
                                }
                            } else {
                                self.translation = .zero
                            }
                            print("Translation on ended \(self.translation)")
                        }
                )
                .environmentObject(profileModel)
                
//                Group {
//                    // Lottie animation - TODO fix animation
//                    if self.buttonSwipeStatus == .like || self.dragSwipeStatus == .like {
//                        // Animation for like given
//                        LottieView(name: "LikeLottie", loopMode: .playOnce)
//                            .frame(width: 220,height: 220)
//
//                    } else if self.buttonSwipeStatus == .dislike || self.dragSwipeStatus == .dislike {
//                        // Animation for dislike given
//                        LottieView(name: "DislikeLottie", loopMode: .playOnce)
//                            .frame(width: 140, height: 140)
//                    }
//                    else if self.buttonSwipeStatus == .superlike || self.dragSwipeStatus == .superlike {
//                       // Animation for superlike given
//                       LottieView(name: "SuperLikeLottie", loopMode: .playOnce)
//                            .frame(width: 400, height: 400)
//                   }
//                }
                
                
                
                VStack {
                    Spacer()
                    LikesDislikesButtons
                        .padding(10)
                }
                .frame(maxWidth: geometry.size.width * 0.5, alignment:.center)
            }
            
        }
    }
    
    var LikesDislikesButtons : some View {
        
        
        HStack(spacing:10) {
            
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
                    self.translation = CGSize(width: -500, height: 0)
                    self.saveLikeSuperlikeDislike(swipeInfo:.dislike) {
                        print("Button Dislike: \(singleProfile.id)")
                    }
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width:55, height:55)
                    .foregroundColor(.gray)
            }
            .disabled(!cardSwipeDone)
            
            Spacer()
            
            // Superlike Button
            Button {
                if cardSwipeDone {
                    cardSwipeDone = false
                    self.saveLikeSuperlikeDislike(swipeInfo:.superlike) {
                        print("Button Dislike: \(singleProfile.id)")
                    }
                }
            } label: {
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .frame(width:40, height:40)
                    .foregroundColor(Color("gold-star"))
            }

            Spacer()
            
            // Like Button
            Button {
                if cardSwipeDone {
                    cardSwipeDone = false
                    self.translation = CGSize(width: 500, height: 0)
                    self.saveLikeSuperlikeDislike(swipeInfo: .like) {
                        print("Button like: \(singleProfile.id)")
                    }
                }
            } label: {
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .frame(width:55, height:55)
                    .foregroundColor(.pink)
            }
            .disabled(!cardSwipeDone)
        }
        
    }
    
}
