//
//  SingleCardView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/9/21.
//

import SwiftUI
import CoreLocation

struct SingleCardView: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @EnvironmentObject var filterModel: FilterModel
    
    @State private var translation: CGSize = .zero
    @Binding var swipeStatus: AllCardsView.LikeDislike
    @State var dragSwipeStatus: AllCardsView.LikeDislike = .none
    var singleProfile: CardProfileWithPhotos
    private var onRemove: (_ user: CardProfileWithPhotos) -> Void
    
    private var thresholdPercentage: CGFloat = 0.15 // when the user has draged 50% the width of the screen in either direction
    
    init(currentSwipeStatus: Binding<AllCardsView.LikeDislike>, singleProfile: CardProfileWithPhotos, onRemove: @escaping (_ user: CardProfileWithPhotos) -> Void) {
        self.singleProfile = singleProfile
        self.onRemove = onRemove
        _swipeStatus = currentSwipeStatus
    }
    
    /// What percentage of our own width have we swipped
    /// - Parameters:
    ///   - geometry: The geometry
    ///   - gesture: The current gesture translation value
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    func getProfile() -> Binding<CardProfileWithPhotos> {
        return Binding {
            cardProfileModel.cardsDictionary[singleProfile.id!] ?? CardProfileWithPhotos()
        } set: { newCard in
            cardProfileModel.cardsDictionary[singleProfile.id!] = newCard
        }
    }
    
    func saveLikeSuperlikeDislike(swipeInfo:AllCardsView.LikeDislike, onSuccess: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
            FirestoreServices.storeLikesDislikes(apiToBeUsed: "/storelikesdislikes", onFailure: {
                return
            }, onSuccess: {
                onSuccess()
                receivedGivenEliteModel.addProfileToArrayFromSwipeView(profileCard: singleProfile,
                                                                       swipeInfo: cardProfileModel.lastSwipeInfo ?? AllCardsView.LikeDislike.none)
            }, swipedUserId: self.singleProfile.id, swipeInfo: swipeInfo)
            self.onRemove(self.singleProfile)
        })
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
            
                ChildCardView(singleProfile: getProfile(),
                              testing:false)
                .animation(.interactiveSpring())
                .offset(x: self.translation.width, y: 0)
                .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 5), anchor: .bottom)
                // Dragging from UI
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.translation = value.translation
                            
                            if (self.getGesturePercentage(geometry, from: value)) >= self.thresholdPercentage {
                                self.dragSwipeStatus = .like
                            } else if self.getGesturePercentage(geometry, from: value) <= -self.thresholdPercentage {
                                self.dragSwipeStatus = .dislike
                            } else {
                                self.dragSwipeStatus = .none
                            }
                            
                    }.onEnded { value in
                        // determine snap distance > 0.5 aka half the width of the screen
                            if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                                self.saveLikeSuperlikeDislike(swipeInfo: self.dragSwipeStatus) {
                                    cardProfileModel.lastSwipeInfo = self.dragSwipeStatus
                                }
                                cardProfileModel.areMoreCardsNeeded(filterData:filterModel.filterData)
                            } else {
                                self.translation = .zero
                            }
                        }
                )
                // Buttons
                .onChange(of: self.swipeStatus) { newValue in
                    if newValue == AllCardsView.LikeDislike.like {
                        self.translation = .init(width: 100, height: 0)
                        self.saveLikeSuperlikeDislike(swipeInfo: self.swipeStatus) {
                            cardProfileModel.lastSwipeInfo = AllCardsView.LikeDislike.like
                        }
                    }
                    else if newValue == AllCardsView.LikeDislike.dislike {
                        self.translation = .init(width: -100, height: 0)
                        self.saveLikeSuperlikeDislike(swipeInfo:self.swipeStatus) {
                            cardProfileModel.lastSwipeInfo = AllCardsView.LikeDislike.dislike
                        }
                    }
                    else if newValue == AllCardsView.LikeDislike.superlike {
                        self.translation = .init(width: 0, height: 50)
                        self.saveLikeSuperlikeDislike(swipeInfo:self.swipeStatus) {
                            cardProfileModel.lastSwipeInfo = AllCardsView.LikeDislike.superlike
                        }
                    }
                    cardProfileModel.areMoreCardsNeeded(filterData:filterModel.filterData)
                }
                .environmentObject(profileModel)
                
                if self.swipeStatus == .like || self.dragSwipeStatus == .like {
                    // Animation for like given
                    LottieView(name: "LikeLottie", loopMode: .playOnce)
                        .frame(width: 200,
                               height: 200)
                    
                    
                } else if self.swipeStatus == .dislike || self.dragSwipeStatus == .dislike {
                    // Animation for dislike given
                    LottieView(name: "DislikeLottie", loopMode: .playOnce)
                        .frame(width: 110,
                               height: 110)
                }
                
            }
            
        }
    }
}

