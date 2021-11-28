//
//  SingleCardView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/9/21.
//

import SwiftUI

struct SingleCardView: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var cardProfileModel: CardProfileModel
    
    @State private var translation: CGSize = .zero
    @Binding var swipeStatus: AllCardsView.LikeDislike
    @State var dragSwipeStatus: AllCardsView.LikeDislike = .none
    var singleProfile: CardProfileWithPhotos
    private var onRemove: (_ user: CardProfileWithPhotos) -> Void
    
    private var thresholdPercentage: CGFloat = 0.15 // when the user has draged 50% the width of the screen in either direction
    
    
//    func saveLikeDislike(givenSwipeStatus: AllCardsView.LikeDislike) {
//        var ref: DocumentReference? = nil
//        var otherUser: String? {
//            switch givenSwipeStatus{
//            case .like: return "likedUser"
//            case .dislike: return "dislikedUser"
//            case .none: return nil
//            }
//        }
//        var collectionName: String? {
//            switch givenSwipeStatus{
//            case .like: return "Likes"
//            case .dislike: return "Dislikes"
//            case .none: return nil
//            }
//        }
//        if let collectionName = collectionName {
//            let collectionRef = db.collection(collectionName)
//            ref = collectionRef.addDocument(data: [
//                "currentUser": String(Auth.auth().currentUser?.uid ?? "testUser"),
//                otherUser!: singleProfile.id
//            ]) { err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Document added with ID: \(ref!.documentID)")
//                }
//            }
//        }
//    }
    
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
            cardProfileModel.cardsDictionary[singleProfile.id!]!
        } set: { newCard in
            cardProfileModel.cardsDictionary[singleProfile.id!] = newCard
        }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
            
                ChildCardView(singleProfile: getProfile(),
                              testing:false)
                .animation(.interactiveSpring())
                .offset(x: self.translation.width, y: 0)
                .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 5), anchor: .bottom)
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
                                self.onRemove(self.singleProfile)
//                                photoModel.clearAllImageCache()
//                                self.saveLikeDislike(givenSwipeStatus: self.dragSwipeStatus)
                                cardProfileModel.areMoreCardsNeeded()
                            } else {
                                self.translation = .zero
                            }
                        }
                )
                .onChange(of: self.swipeStatus) { newValue in
                    if newValue == AllCardsView.LikeDislike.like {
                        self.translation = .init(width: 100, height: 0)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                                                    self.onRemove(self.singleProfile)
                                                })
//                        photoModel.clearAllImageCache()
//                        self.saveLikeDislike(givenSwipeStatus: self.swipeStatus)
                        cardProfileModel.areMoreCardsNeeded()
                    }
                    else if newValue == AllCardsView.LikeDislike.dislike {
                        self.translation = .init(width: -100, height: 0)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                                                    self.onRemove(self.singleProfile)
                                                })
//                        photoModel.clearAllImageCache()
//                        self.saveLikeDislike(givenSwipeStatus: self.swipeStatus)
                    }
                }
                
            
                if self.swipeStatus == .like || self.dragSwipeStatus == .like {
                    LikeDislikeButtons(buttonName: "Like", buttonColor: Color.green, rotationAngle: -45,imageName:"bolt.heart.fill")
                } else if self.swipeStatus == .dislike || self.dragSwipeStatus == .dislike {
                    LikeDislikeButtons(buttonName: "DisLike", buttonColor: Color.red, rotationAngle: 45,imageName:"heart.slash.fill")
                }
            }
            
        }
    }
}

