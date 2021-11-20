//
//  AllCardsView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/9/21.
//


import SwiftUI

struct AllCardsView: View {
    /// List of users
//    @State var users: [User] = [
//        User(id: 1, firstName: "Mark", lastName: "Bennett", age: 27, profileDistanceFromUser: 0, imageName1: "girl2_image1",imageName2: "girl2_image2",imageName3: "girl2_image3", imageName4:"girl2_image4",imageName5: "girl2_image5",imageName6: "girl2_image6", occupation: "Insurance Agent", passions: ["Drink","Gaming","Partying"], height: 6.1, education:"Bachelor",religion:"Hindu",politics:"Liberal",location:"Delhi, IN",
//             description:"You are strong because you are imperfect"),
//        User(id: 3, firstName: "Mark", lastName: "Bennett", age: 27, profileDistanceFromUser: 0, imageName1: "girl2_image1",imageName2: "girl2_image2",imageName3: "girl2_image3", imageName4:"girl2_image4",imageName5: "girl2_image5",imageName6: "girl2_image6", occupation: "Insurance Agent", passions: ["Drink","Gaming","Partying"], height: 6.1, education:"Bachelor",religion:"Hindu",politics:"Liberal",location:"Delhi, IN",
//             description:"You are strong because you are imperfect"),
//        User(id: 4, firstName: "Clayton", lastName: "Delaney", age: 20, profileDistanceFromUser: 1, imageName1: "girl1_image1",imageName2: "girl1_image2",imageName3: "girl1_image3",imageName4: "girl1_image4",imageName5: "girl1_image5",imageName6: "girl1_image6", occupation: "Food Scientist", passions: ["Photography","Drink","Gaming","Partying"], height: 5.11, education:"Bachelor",religion:"Hindu",politics:"Liberal",location:"Bangalore, IN",description:"Here is a women who is always tired, because she lives a life where too much is required"),
//        User(id: 5, firstName: "Clayton", lastName: "Delaney", age: 20, profileDistanceFromUser: 1, imageName1: "girl1_image1",imageName2: "girl1_image2",imageName3: "girl1_image3",imageName4: "girl1_image4",imageName5: "girl1_image5",imageName6: "girl1_image6", occupation: "Food Scientist", passions: ["Photography","Drink","Gaming","Partying"], height: 5.8, education:"Bachelor",religion:"Hindu",politics:"Liberal",location:"Bangalore, IN",description:"Here is a women who is always tired, because she lives a life where too much is required"),
//        User(id: 6, firstName: "Anna", lastName: "Bennett", age: 24, profileDistanceFromUser: 9, imageName1: "onboarding_girl4",imageName2: "onboarding_girl2",imageName3: "onboarding_girl3", imageName4:"onboarding_girl9",imageName5: "onboarding_girl5",imageName6: "onboarding_girl6", occupation: "Insurance Agent", passions: ["Drink","Gaming","Partying","Jumping","Cooking"], height: 6.2, education:"Bachelor",religion:"Hindu",politics:"Liberal",location:"Delhi, IN",description:"You are strong because you are imperfect"),
//        User(id: 2, firstName: "Mark", lastName: "Bennett", age: 27, profileDistanceFromUser: 0, imageName1: "girl2_image1",imageName2: "girl2_image2",imageName3: "girl2_image3", imageName4:"girl2_image4",imageName5: "girl2_image5",imageName6: "girl2_image6", occupation: "Insurance Agent", passions: ["Drink","Gaming","Partying"], height: 6.3, education:"Bachelor",religion:"Hindu",politics:"Liberal",location:"Delhi, IN",
//             description:"You are strong because you are imperfect")
//    ]
    
    
    @State var numberOfProfilesSwiped = 0
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    @State var curSwipeStatus: LikeDislike = .none
    @State var allCards: [CardProfile]
    
    
    enum LikeDislike: Int {
        case like, dislike, none
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(allCards) { profile in
                        /// Using the pattern-match operator ~=, we can determine if our
                        /// user.id falls within the range of 6...9
                        
                        // Normal Card View being rendered here.
                        SingleCardView(currentSwipeStatus: self.allCards.last == profile ?
                                       $curSwipeStatus : Binding.constant(LikeDislike.none),
                                       singleProfile: profile,
                                       onRemove: { removedUser in
                                            // Remove that user from our array
                                            self.allCards.removeAll { $0.id == removedUser.id }
                                            self.curSwipeStatus = .none
                                        }
                        )
                        .animation(.spring())
                        .frame(width: geometry.size.width)
                        
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

//struct AllCardsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllCardsView()
//    }
//}
//


