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
    @EnvironmentObject var storeManager: StoreManager
    
    @Binding var cardSwipeDone: Bool
    @Binding var allcardsActiveSheet: AllCardsActiveSheet?
    
    @State var singleProfile: CardProfileWithPhotos
    @State var translation: CGSize = .zero
    @GestureState var dragOffset: CGSize = .zero
    
    @State var swipeStatus: AllCardsView.LikeDislike = .none
    @State var cardColor: Color = Color.clear
    
    var onRemove: (_ user: CardProfileWithPhotos) -> Void
    
    var thresholdPercentage: CGFloat = 0.15 // when the user has draged 50% the width of the screen in either direction
    
    var totalSuperCount: Int {
        let purchasedSuperLikesCount =  self.storeManager.purchaseDataDetails.purchasedSuperLikesCount ?? 0
        let subscriptionSuperLikeCount =  self.storeManager.purchaseDataDetails.subscriptionSuperLikeCount ?? 0
        return purchasedSuperLikesCount+subscriptionSuperLikeCount
    }
    
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
                self.swipeStatus = .none
                self.onRemove(self.singleProfile)
                self.cardSwipeDone = true
                cardProfileModel.areMoreCardsNeeded(filterData:filterModel.filterData)
            }, swipedUserId: self.singleProfile.id, swipeInfo: swipeInfo)
        })
    }
    
    func checkSwipeGesture(geometry:GeometryProxy, value: DragGesture.Value) {
        if (self.getGesturePercentage(geometry, from: value)) >= self.thresholdPercentage {
                self.swipeStatus = .like
                self.cardColor = .green
            } else if self.getGesturePercentage(geometry, from: value) <= -self.thresholdPercentage {
                self.swipeStatus = .dislike
                self.cardColor = .red
            } else {
                self.swipeStatus = .none
            }
    }
    
    
    func consumeASuperlike() {
        // Since Subscriptions expire everyday, make sure to consume the dail subscriptions first before consuming the purcahses
        if let subscriptionSuperLikeCount = storeManager.purchaseDataDetails.subscriptionSuperLikeCount {
            if subscriptionSuperLikeCount > 0 {
                storeManager.purchaseDataDetails.subscriptionSuperLikeCount.boundInt -= 1
            } else {
                if let purchasedSuperLikesCount = storeManager.purchaseDataDetails.purchasedSuperLikesCount {
                    if purchasedSuperLikesCount > 0 {
                        storeManager.purchaseDataDetails.purchasedSuperLikesCount.boundInt -= 1
                    }
                }
            }
        }
    }
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
            
                ChildCardView(singleProfile: getProfile(),
                              swipeStatus:$swipeStatus,
                              cardColor:$cardColor)
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
                                self.saveLikeSuperlikeDislike(swipeInfo: self.swipeStatus) {}
                                withAnimation {
                                    // For smoother swipe of the card
                                    self.translation = cardGesturePct < 0 ? CGSize(width: -500, height: 0) : CGSize(width: 500, height: 0)
                                }
                            } else {
                                self.translation = .zero
                            }
                        }
                )
                .environmentObject(profileModel)
                
                
                Group {
                     if self.swipeStatus == .superlike  {
                       // Animation for superlike given
                       LottieView(name: "SuperLikeLottie", loopMode: .playOnce)
                            .frame(width: 400, height: 400)
                   }
                }
                
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
        HStack(spacing:20) {
            RewindButton
            DislikeButton
            SuperLikeButton
            LikeButton
            DMButton
        }
        
    }
    
    // Rewind BUtton
    var RewindButton : some View {
        // RewindButton
        Button {
            if cardSwipeDone {
                cardSwipeDone = false
                FirestoreServices.undoLikeDislikeFirestore(apiToBeUsed: "/rewindswipesingle", onFailure: {
                    cardSwipeDone = true
                }, onSuccess: {
                    rewindedDict in
                    
                    // Append the rewinded card back to the dictionary
                    let rewindedUserCard = rewindedDict.rewindedUserCard
                    
                    let cardProfileWithPhotos = CardProfileModel.cardProfileToCardProfileWithPhotos(card: rewindedUserCard)
                    // Append rewinded user in Array
                    cardProfileModel.allCardsWithPhotosDeck.append(cardProfileWithPhotos)
                    // Append rewinded user in Dict
                    if let rewindedUserId = cardProfileWithPhotos.id {
                        cardProfileModel.cardsDictionary[rewindedUserId] = cardProfileWithPhotos
                        receivedGivenEliteModel.rewindAction(swipedUserId: rewindedUserId)
                    }
                    
                    // Find the kind of rewind, like, dislike or superlike
                    // if superlike increment the superlike
                    let swipeStatusBetweenUsers = rewindedDict.swipeStatusBetweenUsers
                    if swipeStatusBetweenUsers == "Superlikes" {
                        if let purchasedSuperLikesCount =  self.storeManager.purchaseDataDetails.purchasedSuperLikesCount {
                            self.storeManager.purchaseDataDetails.purchasedSuperLikesCount = purchasedSuperLikesCount+1
                            _ = self.storeManager.storePurchaseNoParams()
                        }
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
    }
    
    // Dislike Button
    var DislikeButton : some View {
        Button {
            self.cardColor = .red
            // If card swiping action is finished
            if cardSwipeDone {
                cardSwipeDone = false
                self.translation = CGSize(width: -500, height: 0)
                self.saveLikeSuperlikeDislike(swipeInfo:.dislike) {
                    print("Button Dislike: \(String(describing: singleProfile.id))")
                }
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width:55, height:55)
                .foregroundColor(.gray)
        }
        .disabled(!cardSwipeDone)
    }
    
    // SuperLike Button
    var SuperLikeButton : some View {
        
        Button {
            // Check if user has a superlike count
            if self.totalSuperCount > 0 {
                self.cardColor = .yellow
                // Consume the super like and it will reduce the super like count
                self.consumeASuperlike()
                _ = storeManager.storePurchaseNoParams()
                self.swipeStatus = .superlike
                if cardSwipeDone {
                    cardSwipeDone = false
                    self.saveLikeSuperlikeDislike(swipeInfo:.superlike) {
                        print("Button Superlike: \(singleProfile.id ?? "")")
                    }
                }
            } else {
                // User doesn't have any superlikes yet, display a sheet to buy more super likes for user
                allcardsActiveSheet = .buyMoreSuperLikesSheet
            }
        } label: {
            if self.swipeStatus == .superlike  {
                ZStack {
                    Circle()
                        .fill(Color("gold-star"))
                        .frame(width: 45, height: 45)
                    
                    Text("\(self.totalSuperCount)")
                        .foregroundColor(Color.white)
                        .bold()
                        .font(.title2)
                }
            } else {
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .frame(width:45, height:45)
                    .foregroundColor(Color("gold-star"))
            }
        }
    }
    
    // Like Button
    var LikeButton : some View {
        Button {
            self.cardColor = .green
            if cardSwipeDone {
                cardSwipeDone = false
                self.translation = CGSize(width: 500, height: 0)
                self.saveLikeSuperlikeDislike(swipeInfo: .like) {
                    print("Button like: \(singleProfile.id ?? "")")
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
 
    // DM Button
    var DMButton: some View {
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
