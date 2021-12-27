//
//  LikesTopPicksButton.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/27/21.
// All Buttons in this class are being using in top picks view

import SwiftUI

// Like Button
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

// Super Like Button
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

// Dislike Button
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


