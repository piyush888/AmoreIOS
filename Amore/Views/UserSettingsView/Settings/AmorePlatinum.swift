//
//  AmorePlatinum.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/28/21.
//

import SwiftUI

struct AmorePlatinum: View {
    
    @State var width: CGFloat = 0.0
    
    var body: some View {
        ZStack{
            Capsule()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.blue]),
                    startPoint: .leading,
                    endPoint: .trailing)
                )
                .frame(width: width, height:70)
            
            VStack {
                Text("Amore Platinum")
                    .font(.headline)
                
                Text("The best dating service for Indians")
                    .font(.caption)
                    .italic()
            }
        }
        .foregroundColor(.white)
        
    }
}

