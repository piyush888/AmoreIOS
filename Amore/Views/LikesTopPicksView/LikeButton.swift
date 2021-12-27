//
//  LikeButton.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/27/21.
//

import SwiftUI

struct LikeButton: View {
    
    @State var profileId: String
    @Binding var show: Bool
    
    var body: some View {
        Button {
            FirestoreServices.storeLikesDislikes(apiToBeUsed: "/storelikesdislikes", onFailure: {
                return
            }, onSuccess: {
                self.show = true
            }, swipedUserId: self.profileId,
            swipeInfo: AllCardsView.LikeDislike.like)
        } label: {
            Image(systemName: "heart.circle.fill")
                .resizable()
                .frame(width:55, height:55)
                .foregroundColor(.pink)
                .padding(.horizontal)
                .shadow(color: .white,
                        radius: 5, x: 1, y: 1)
        }
    }
}

