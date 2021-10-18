//
//  CardView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/18/21.
//

import SwiftUI

struct CardView: View {
    var item: TopPicksProfiles
    var animation: Namespace.ID
    
    var body: some View {
        
            VStack{
                
                Image(item.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 180, height: 200, alignment: .center)
                    .cornerRadius(10)
                    .matchedGeometryEffect(id: "image\(item.id)", in: animation)
                    .padding(.horizontal,5)
                    .overlay(Text("\(item.firstName), \(item.age)").padding(),alignment:.bottomLeading)
                    .foregroundColor(Color.white)
                    .font(.caption)
                    
            }
        
        // giving hero effect for color also...
        .background(
            Color(item.image)
                .matchedGeometryEffect(id: "color\(item.id)", in: animation)
        )
        .cornerRadius(15)
    }
}

