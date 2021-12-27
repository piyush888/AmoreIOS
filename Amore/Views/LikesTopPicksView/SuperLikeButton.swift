//
//  SuperLikeButton.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/27/21.
//

import SwiftUI

struct SuperLikeButton: View {
    
    @State var profileId: String
    @Binding var show: Bool
    
    var body: some View {
        Button {
            FirestoreServices.storeLikesDislikes(apiToBeUsed: "/storelikesdislikes", onFailure: {
                return
            }, onSuccess: {
                self.show = true
            }, swipedUserId: self.profileId,
            swipeInfo: AllCardsView.LikeDislike.superlike)
        } label: {
            Image(systemName: "star.circle.fill")
                .resizable()
                .frame(width:40, height:40)
                .foregroundColor(Color("gold-star"))
                .shadow(color: .white,
                        radius: 1, x: 1, y: 1)
        }

    }
}


