////
////  DeckCards.swift
////  Amore
////
////  Created by Kshitiz Sharma on 11/26/21.
////
//
//import SwiftUI
//
//struct DeckCards: View {
//
//    @EnvironmentObject var cardProfileModel: CardProfileModel
//    @EnvironmentObject var photoModel: PhotoModel
//
//    @Binding var cardDecks: [CardProfileWithPhotos]
//    @State var cardWidth: CGFloat
//    @Binding var curSwipeStatus: AllCardsView.LikeDislike
//
//
//    var body: some View {
//
////        ForEach(self.cardDecks) { profile in
////            // Normal Card View being rendered here.
////            SingleCardView(currentSwipeStatus: self.cardDecks.last == profile ?
////                           $curSwipeStatus : Binding.constant(AllCardsView.LikeDislike.none),
////                           singleProfile: profile,
////                           onRemove: { removedUser in
////                                // Remove that user from our array
////                self.cardDecks.removeAll { $0.id == removedUser.id }
////                                self.curSwipeStatus = .none
////                            }
////            )
////            .animation(.spring())
////            .frame(width: cardWidth)
////            .environmentObject(photoModel)
////            .environmentObject(cardProfileModel)
////
////        }
//        Text("")
//
//    }
//}
//
//


//
//  SingleCardView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/9/21.
//

import SwiftUI
import CoreLocation

struct SingleCard: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @EnvironmentObject var filterModel: FilterModel
    
    @Binding var cardSwipeDone: Bool
    @Binding var swipeStatus: AllCardsView.LikeDislike
    
    @State var singleProfile: CardProfileWithPhotos
    @State var translation: CGSize = .zero
    @GestureState var dragOffset: CGSize = .zero
    
    @State var dragSwipeStatus: AllCardsView.LikeDislike = .none
    @State var isScrollable: AllCardsView.LikeDislike = .none
    
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
                receivedGivenEliteModel.addProfileToArrayFromSwipeView(profileCard: singleProfile,
                                                                       swipeInfo: dragSwipeStatus == .none ? swipeStatus : dragSwipeStatus)
                cardProfileModel.areMoreCardsNeeded(filterData:filterModel.filterData)
                self.cardSwipeDone = true
            }, swipedUserId: self.singleProfile.id, swipeInfo: swipeInfo)
        })
        self.onRemove(self.singleProfile)
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
                // Buttons
                .onChange(of: self.swipeStatus) { newValue in
                    if newValue == AllCardsView.LikeDislike.like {
                        self.translation = CGSize(width: 500, height: 0)
                        self.saveLikeSuperlikeDislike(swipeInfo: self.swipeStatus) {}
                    }
                    else if newValue == AllCardsView.LikeDislike.dislike {
                        self.translation = CGSize(width: -500, height: 0)
                        self.saveLikeSuperlikeDislike(swipeInfo:self.swipeStatus) {}
                    }
                    else if newValue == AllCardsView.LikeDislike.superlike {
                        self.saveLikeSuperlikeDislike(swipeInfo:self.swipeStatus) {}
                    }
                }
                
                .environmentObject(profileModel)
                
                
                
                
                
                // Animation
                if self.swipeStatus == .like || self.dragSwipeStatus == .like {
                    // Animation for like given
                    LottieView(name: "LikeLottie", loopMode: .playOnce)
                        .frame(width: 220,height: 220)
                    
                } else if self.swipeStatus == .dislike || self.dragSwipeStatus == .dislike {
                    // Animation for dislike given
                    LottieView(name: "DislikeLottie", loopMode: .playOnce)
                        .frame(width: 140, height: 140)
                }
                else if self.swipeStatus == .superlike || self.dragSwipeStatus == .superlike {
                   // Animation for superlike given
                   LottieView(name: "SuperLikeLottie", loopMode: .playOnce)
                        .frame(width: 400, height: 400)
               }
                
            }
            
        }
    }
}
