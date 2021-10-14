//
//  LikeDislikeSuperLike.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/6/21.
//

import SwiftUI

struct LikeDislikeSuperLike: View {
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "arrow.uturn.backward")
                .resizable()
                .frame(width:25, height:25)
                .foregroundColor(.orange)
            
            Spacer()
            
            Image(systemName: "xmark.circle")
                .resizable()
                .frame(width:44, height:44)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            Spacer()
            
            Image(systemName: "star.circle")
                .resizable()
                .frame(width:35, height:35)
                .foregroundColor(Color("gold-star"))
                
            Spacer()
            
            Image(systemName: "heart.circle.fill")
                .resizable()
                .frame(width:44, height:44)
                .foregroundColor(.pink)
                .padding(.horizontal)
                .shadow(color: .pink,
                        radius: 0.1, x: 1, y: 1)
            
            Spacer()
            
            Image(systemName: "bolt.circle.fill")
                .resizable()
                .frame(width:35, height:35)
                .foregroundColor(.blue)
                .shadow(color: .blue,
                        radius: 0.1, x: 1, y: 1)
                
        }.padding(.horizontal,20)
    }
}

struct LikeDislikeSuperLike_Previews: PreviewProvider {
    static var previews: some View {
        LikeDislikeSuperLike()
    }
}
