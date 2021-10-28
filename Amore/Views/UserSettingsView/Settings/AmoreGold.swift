//
//  AmoreGold.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/28/21.
//

import SwiftUI

struct AmoreGold: View {
    
    @State var width: CGFloat = 0.0
    
    var body: some View {
            
        // Amore Gold
        ZStack{
            Capsule()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.yellow, Color.red]),
                    startPoint: .leading,
                    endPoint: .trailing)
                )
                .frame(width:width, height:70)
            
            VStack {
                Text("Amore Gold")
                    .font(.headline)
                
                Text("Find your Dil today, Don't make them wait")
                    .font(.caption)
                    .italic()
            }
        }
        .padding(.top,10)
        .foregroundColor(.white)
        
        
        
    }
}


