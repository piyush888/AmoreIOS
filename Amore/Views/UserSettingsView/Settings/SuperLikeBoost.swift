//
//  SuperLikeBoost.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/28/21.
//

import SwiftUI

struct SuperLikeBoost: View {
    
    @State var width: CGFloat = 0.0
    
    var body: some View {
        
        HStack {
            
            ZStack{
                
                Capsule()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.white]),
                        startPoint: .leading,
                        endPoint: .trailing)
                    )
                    .frame(width:width, height:70)
                    .shadow(color: Color.black, radius: 2, x: 0.5, y: 0.5)
                
                VStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width:25, height:25)
                        .foregroundColor(Color("gold-star"))
                    Text("6 Super Likes")
                        .font(.caption)
                }
            }
            .padding(.top,10)
            .foregroundColor(.white)
            
            
            ZStack{
                Capsule()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.blue]),
                        startPoint: .leading,
                        endPoint: .trailing)
                    )
                    .frame(width:width, height:70)
                    .shadow(color: Color.black, radius: 2, x: 0.5, y: 0.5)
                
                VStack {
                    Image(systemName: "bolt.circle.fill")
                        .resizable()
                        .frame(width:25, height:25)
                        .foregroundColor(.blue)
                        .shadow(color: .blue,
                                radius: 0.1, x: 1, y: 1)
                    Text("1 Boost")
                        .font(.subheadline)
                }
            }
            .padding(.top,10)
            .foregroundColor(.white)
            
        }
        
        
        
        
    }
}


