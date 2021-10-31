//
//  AmoreGold.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/28/21.
//

import SwiftUI

struct AmoreGold: View {
    
    @State var width: CGFloat = 0.0
    @Binding var popUpCardSelection: PopUpCards
    @Binding var showModal: Bool
    
    var body: some View {
            
        
        Button {
            popUpCardSelection = .amoreGold
            showModal.toggle()
        } label: {
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
            .foregroundColor(.white)
            
        }
    }
}


