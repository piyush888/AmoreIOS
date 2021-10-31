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
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(bgColor)

            
            VStack {
                
                Spacer()
                
                HStack {
                
                    Spacer()
                    
                        
                    Button {
                        popUpCardSelection = .superLikeCards
                        showModal = true
                    } label: {
                        VStack {
                        
                        Image(systemName: "star.circle.fill")
                            .resizable()
                            .frame(width:50, height:50)
                            .foregroundColor(Color("gold-star"))
                        Text("6 Super Likes")
                            .font(.caption2)
                        }
                    }
                    
                    Spacer()
                    
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
                            Text("1 Boost")
                                .font(.caption2)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        popUpCardSelection = .messagesCards
                        showModal = true
                    } label: {
                        VStack {
                            Image(systemName: "message.circle.fill")
                                .resizable()
                                .frame(width:50, height:50)
                                .foregroundColor(.pink)
                            Text("3 messages ")
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

