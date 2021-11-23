//
//  SingleCardView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/9/21.
//

import SwiftUI

struct SingleCardView: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    
    @State private var translation: CGSize = .zero
    @Binding var swipeStatus: AllCardsView.LikeDislike
    @State var dragSwipeStatus: AllCardsView.LikeDislike = .none
    public var singleProfile: CardProfile
    private var onRemove: (_ user: CardProfile) -> Void
    
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
    
    init(currentSwipeStatus: Binding<AllCardsView.LikeDislike>, singleProfile: CardProfile, onRemove: @escaping (_ user: CardProfile) -> Void) {
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
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
            
                ChildCardView(imageURL1: self.singleProfile.image1?.imageURL,
                         imageURL2: self.singleProfile.image2?.imageURL,
                         imageURL3: self.singleProfile.image3?.imageURL,
                         imageURL4: self.singleProfile.image4?.imageURL,
                         imageURL5: self.singleProfile.image5?.imageURL,
                         imageURL6: self.singleProfile.image6?.imageURL,
                         firstName: self.singleProfile.firstName!,
                         lastName: self.singleProfile.lastName!,
                         profileDistanceFromUser:self.singleProfile.profileDistanceFromUser ?? 0,
                         description: self.singleProfile.description ?? "No Description",
                         height: self.singleProfile.height ?? 0.0,
                         occupation: self.singleProfile.jobTitle ?? "No Job",
                         education: self.singleProfile.education ?? "No Education",
                         religion: self.singleProfile.religion ?? "No Religion",
                         politics: self.singleProfile.politics ?? "No Politics",
                         location: self.singleProfile.location ?? "No Location",
                         passions: self.singleProfile.interests ?? ["No Interests"],
                         geometry:geometry,
                         age: self.singleProfile.age ?? 10
                )
                
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
                                photoModel.clearAllImageCache()
//                                self.saveLikeDislike(givenSwipeStatus: self.dragSwipeStatus)
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
//                        self.saveLikeDislike(givenSwipeStatus: self.swipeStatus)
                    }
                    else if newValue == AllCardsView.LikeDislike.dislike {
                        self.translation = .init(width: -100, height: 0)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                                                    self.onRemove(self.singleProfile)
                                                })
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

// 7
//struct SingleCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleCardView(currentSwipeStatus: Binding.constant(AllCardsView.LikeDislike.none), user:User(id: 0, firstName: "Mark", lastName: "Bennett", age: 27, profileDistanceFromUser: 15, imageName1: "onboarding_girl4",imageName2: "onboarding_girl2",imageName3: "onboarding_girl3", imageName4:"onboarding_girl9",imageName5: "onboarding_girl5",imageName6: "onboarding_girl6", occupation: "Insurance Agent", passions: ["Drink","Gaming","Partying"], height: 6.1, education:"Bachelor",religion:"Hindu",politics:"Liberal",location:"Delhi, IN",
//                                                                                                               description:"You are strong because you are imperfect"),
//                 onRemove: { _ in
//                    // do nothing
//        }).padding(.horizontal,10)
//    }
//}
