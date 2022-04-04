//
//  SubscriptionDetails.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/23/21.
//

import SwiftUI

struct SubscriptionDetails: View {
    
    @Binding var popUpCardSelection: PopUpCards
    @Binding var showModal: Bool
    @State var bgColor: Color
    @EnvironmentObject var storeManager: StoreManager
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(bgColor)

            VStack {
                
                Spacer()
                
                HStack {
                
                    Spacer()
                    
                    // Buy Super Likes & show the count of the super likes
                    Button {
                        popUpCardSelection = .superLikeCards
                        showModal = true
                    } label: {
                        VStack {
                        
                        Image(systemName: "star.circle.fill")
                            .resizable()
                            .frame(width:50, height:50)
                            .foregroundColor(Color("gold-star"))
                            Text("\(storeManager.purcahseDataDetails.totalSuperLikesCount ?? 0) Super Likes")
                            .font(.caption2)
                        }
                    }
                    
                    Spacer()
                    
                    // Buy Boosts and show the count of boosts
                    Button {
                        popUpCardSelection = .boostCards
                        showModal = true
                    } label: {
                        VStack {
                            Image(systemName: "bolt.circle.fill")
                                .resizable()
                                .frame(width:50, height:50)
                                .foregroundColor(.blue)
                                .shadow(color: .blue,
                                        radius: 0.1, x: 1, y: 1)
                            Text("\(storeManager.purcahseDataDetails.totalBoostCount  ?? 0) Boost")
                                .font(.caption2)
                        }
                    }
                    
                    Spacer()
                    
                    
                    // Buy Message Options
                    Button {
                        popUpCardSelection = .messagesCards
                        showModal = true
                    } label: {
                        VStack {
                            Image(systemName: "message.circle.fill")
                                .resizable()
                                .frame(width:50, height:50)
                                .foregroundColor(.pink)
                            Text("\(storeManager.purcahseDataDetails.totalMessagesCount  ?? 0) Messages")
                                .font(.caption2)
                        }
                    }
                    
                    Spacer()
                    
                    //Restore products already purchased
                    Button {
                        storeManager.restoreProducts()
                    } label: {
                        VStack {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .resizable()
                                .frame(width:50, height:50)
                                .foregroundColor(.green)
                            Text("Restore")
                                .font(.caption2)
                        }
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
}

