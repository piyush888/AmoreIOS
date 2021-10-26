//
//  AllCardsView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/9/21.
//


import SwiftUI

struct User: Hashable, CustomStringConvertible {
    var id: Int
    
    let firstName: String
    let lastName: String
    let age: Int
    let profileDistanceFromUser: Int
    let imageName1: String
    let imageName2: String
    let imageName3: String
    let imageName4: String
    let imageName5: String
    let imageName6: String
    let occupation: String
    let passions: [String]
    let height: String
    let education: String
    let religion: String
    let politics: String
    let location: String
    let description: String
}

struct AllCardsView: View {
    /// List of users
    @State var users: [User] = [
        User(id: 0, firstName: "Cindy", lastName: "Jones", age: 23, profileDistanceFromUser: 4, imageName1: "girl1_image1",imageName2: "girl1_image2",imageName3: "girl1_image3",imageName4: "girl1_image4",imageName5: "girl1_image5",imageName6: "girl1_image6", occupation: "Coach", passions: ["Photography", "Shopping"], height: "5 55", education:"Bachelor",religion:"Hindu",politics:"Liberal", location:"Texas, US", description:"You are strong because you are imperfect, you have doubts because you are wise"),
        User(id: 1, firstName: "Mark", lastName: "Bennett", age: 27, profileDistanceFromUser: 0, imageName1: "girl2_image1",imageName2: "girl2_image2",imageName3: "girl2_image3", imageName4:"girl2_image4",imageName5: "girl2_image5",imageName6: "girl2_image6", occupation: "Insurance Agent", passions: ["Drink","Gaming","Partying"], height: "6 1''", education:"Bachelor",religion:"Hindu",politics:"Liberal",location:"Delhi, IN",
             description:"You are strong because you are imperfect"),
        User(id: 2, firstName: "Clayton", lastName: "Delaney", age: 20, profileDistanceFromUser: 1, imageName1: "girl1_image1",imageName2: "girl1_image2",imageName3: "girl1_image3",imageName4: "girl1_image4",imageName5: "girl1_image5",imageName6: "girl1_image6", occupation: "Food Scientist", passions: ["Photography","Drink","Gaming","Partying"], height: "10 1", education:"Bachelor",religion:"Hindu",politics:"Liberal",location:"Bangalore, IN",description:"Here is a women who is always tired, because she lives a life where too much is required")
    ]
    
    enum LikeDislike: Int {
        case like, dislike, none
    }
    @State var curSwipeStatus: LikeDislike = .none
    
    /// Return the CardViews width for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current user
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(users.count - 1 - id) * 10
        return geometry.size.width - offset
    }
    
    /// Return the CardViews frame offset for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current user
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(users.count - 1 - id) * 10
    }
    
    private var maxID: Int {
        return self.users.map { $0.id }.max() ?? 0
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(self.users, id: \.self) { user in
                        
                        /// Using the pattern-match operator ~=, we can determine if our
                        /// user.id falls within the range of 6...9
                        
                        if (self.maxID - 3)...self.maxID ~= user.id {
                            // Normal Card View being rendered here.
                            SingleCardView(currentSwipeStatus: self.users.last == user ?
                                           $curSwipeStatus
                                           : Binding.constant(LikeDislike.none),
                                           user: user,
                                           onRemove: { removedUser in
                                // Remove that user from our array
                                self.users.removeAll { $0.id == removedUser.id }
                                self.curSwipeStatus = .none
                            })
                            .animation(.spring())
                            .frame(width: geometry.size.width)
                        }
                    }
                }
                LikeDislikeSuperLike(curSwipeStatus: $curSwipeStatus)
                .padding()
            }
        }.padding(.horizontal)
    }
}

struct AllCardsView_Previews: PreviewProvider {
    static var previews: some View {
        AllCardsView()
    }
}



