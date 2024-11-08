//
//  SubscriptionDetails.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/23/21.
//

import SwiftUI

struct SubscriptionDetails: View {
    
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var storeManager: StoreManager
    @Binding var popUpCardSelection: PopUpCards
    @Binding var backgroundColor: Color
    
    var totalSuperLikesCount: Int {
        let purchasedSuperLikesCount =  self.storeManager.purchaseDataDetails.purchasedSuperLikesCount ?? 0
        let subscriptionSuperLikeCount =  self.storeManager.purchaseDataDetails.subscriptionSuperLikeCount ?? 0
        return purchasedSuperLikesCount+subscriptionSuperLikeCount
    }
    
    var totalBoostCount: Int {
        let purchasedBoostCount =  self.storeManager.purchaseDataDetails.purchasedBoostCount ?? 0
        let subscriptonBoostCount =  self.storeManager.purchaseDataDetails.subscriptonBoostCount ?? 0
        return purchasedBoostCount+subscriptonBoostCount
    }
    
    var totalMessagesCount: Int {
        let purchasedMessagesCount =  self.storeManager.purchaseDataDetails.purchasedMessagesCount ?? 0
        let subscriptionMessageCount =  self.storeManager.purchaseDataDetails.subscriptionMessageCount ?? 0
        return purchasedMessagesCount+subscriptionMessageCount
    }
    
    var totalRewindsCount: Int {
        let purchasedRewindsCount =  self.storeManager.purchaseDataDetails.purchasedRewindsCount ?? 0
        let subscriptionRewindsCount =  self.storeManager.purchaseDataDetails.subscriptionRewindsCount ?? 0
        return purchasedRewindsCount+subscriptionRewindsCount
    }
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(backgroundColor ?? Color.clear)

            HStack(spacing:20) {
            
                // Buy Super Likes & show the count of the super likes
                Button {
                    popUpCardSelection = .superLikeCards
                    storeManager.displayProductModalWindow = true
                } label: {
                    VStack {
                        Image(systemName: "star.circle.fill")
                            .resizable()
                            .frame(width:50, height:50)
                            .foregroundColor(Color("gold-star"))
                        Text("\(self.totalSuperLikesCount) Super Likes")
                        .font(.caption2)
                    }
                }
                
                // Buy Boosts and show the count of boosts
                Button {
                    popUpCardSelection = .boostCards
                    storeManager.displayProductModalWindow = true
                } label: {
                    VStack {
                        Image(systemName: "bolt.circle.fill")
                            .resizable()
                            .frame(width:50, height:50)
                            .foregroundColor(.blue)
                            .shadow(color: .blue, radius: 0.1, x: 1, y: 1)
                        Text("\(self.totalBoostCount) Boost")
                            .font(.caption2)
                    }
                }
                
                
                // Buy Message Options
                Button {
                    popUpCardSelection = .messagesCards
                    storeManager.displayProductModalWindow = true
                } label: {
                    VStack {
                        Image(systemName: "message.circle.fill")
                            .resizable()
                            .frame(width:50, height:50)
                            .foregroundColor(.pink)
                        Text("\(self.totalMessagesCount) Messages")
                            .font(.caption2)
                    }
                }
                
                // Buy Rewinds
                Button {
                    popUpCardSelection = .rewindCards
                    storeManager.displayProductModalWindow = true
                } label: {
                    VStack {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .resizable()
                            .frame(width:50, height:50)
                            .foregroundColor(.orange)
                        Text("\(self.totalRewindsCount) Replays")
                            .font(.caption2)
                    }
                }
                
                
            }
            .padding(.vertical,5)
        }
        
    }
}

