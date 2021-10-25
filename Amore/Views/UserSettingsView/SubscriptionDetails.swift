//
//  SubscriptionDetails.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/23/21.
//

import SwiftUI

struct SubscriptionDetails: View {
    
    let skyBlue = Color(red: 0.80, green: 1.0, blue: 1.0)

    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(skyBlue)
            
            VStack {
                
                Spacer()
                
                HStack {
                
                    Spacer()
                    
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .frame(width:50, height:50)
                            .foregroundColor(Color("gold-star"))
                        Text("6 Super Likes")
                            .font(.caption2)
                    }
                    
                    Spacer()
                    
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
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "bonjour")
                            .resizable()
                            .frame(width:42, height:42)
                            .foregroundColor(.blue)
                            .shadow(color: .blue,
                                    radius: 0.1, x: 1, y: 1)
                        Text("Upgrade")
                            .font(.caption2)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                ZStack{
                    Rectangle()
                        .cornerRadius(10.0)
                        .frame(height:45)
                        .foregroundColor(.clear)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 1))
                        .padding(.horizontal,70)
                        
                    Text("My Amore")
                        .foregroundColor(.green)
                        .bold()
                        .font(.BoardingButton)
                }
                Spacer()
                
            }
        }
    }
}

struct SubscriptionDetails_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionDetails()
    }
}
