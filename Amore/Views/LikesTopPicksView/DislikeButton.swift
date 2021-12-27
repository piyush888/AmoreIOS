//
//  DislikeButton.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/27/21.
//

import SwiftUI

struct DislikeButton: View {
    
    @State var profileId: String
    @Binding var show: Bool
    
    var body: some View {
        
        Button {
            FirestoreServices.storeLikesDislikes(apiToBeUsed: "/storelikesdislikes", onFailure: {
                return
            }, onSuccess: {
                self.show = true
            }, swipedUserId: self.profileId,
            swipeInfo: AllCardsView.LikeDislike.dislike)
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width:55, height:55)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .shadow(color: .white,
                        radius: 5, x: 1, y: 1)
        }
    }
}

