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
            
            Spacer()
            
            Image(systemName: "arrow.uturn.backward.circle.fill")
                .resizable()
                .frame(width:35, height:35)
                .foregroundColor(.orange)
                .shadow(color: .orange,
                        radius: 0.5, x: 1, y: 1)
                
            
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width:40, height:40)
                .foregroundColor(.red)
                .padding(.horizontal)
                .shadow(color: .red,
                        radius: 0.5, x: 1, y: 1)
                
            
            Image(systemName: "star.circle")
                .resizable()
                .frame(width:35, height:35)
                .foregroundColor(.purple)
                .shadow(color: .purple,
                        radius: 0.5, x: 1, y: 1)
                
            
            Image(systemName: "heart.circle.fill")
                .resizable()
                .frame(width:40, height:40)
                .foregroundColor(.pink)
                .padding(.horizontal)
                .shadow(color: .pink,
                        radius: 0.5, x: 1, y: 1)
                
            
            Image(systemName: "bolt.circle.fill")
                .resizable()
                .frame(width:35, height:35)
                .foregroundColor(.blue)
                .shadow(color: .blue,
                        radius: 0.5, x: 1, y: 1)
                
            
            Spacer()
        }
    }
}

struct LikeDislikeSuperLike_Previews: PreviewProvider {
    static var previews: some View {
        LikeDislikeSuperLike()
    }
}
