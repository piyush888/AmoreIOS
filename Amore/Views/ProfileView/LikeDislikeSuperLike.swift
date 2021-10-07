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
            
            Image(systemName: "xmark.circle")
                .resizable()
                .frame(width:65, height:65)
                .foregroundColor(.red)
            
            Image(systemName: "heart.circle.fill")
                .resizable()
                .frame(width:75, height:75)
                .foregroundColor(.pink)
                .padding(.horizontal,25)
            
            
            Image(systemName: "star.circle")
                .resizable()
                .frame(width:65, height:65)
                .foregroundColor(Color.purple)
            
        }
    }
}
