//
//  MyAmore.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/29/21.
//

import SwiftUI

struct MyAmore: View {
    
    @State var width: CGFloat = 0.0
    @Binding var popUpCardSelection: PopUpCards
    @Binding var showModal: Bool
    
    
    var body: some View {
        
        
        VStack {
            
            Button {
                showModal = true
                popUpCardSelection = .myAmorecards
            } label: {
                // Amore Gold
                ZStack{
                    Capsule()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.pink, Color.orange, Color.pink]),
                            startPoint: .leading,
                            endPoint: .trailing)
                        )
                        .frame(width:width, height:70)
                    
                    VStack {
                        Text("My Amore")
                            .font(.headline)
                    }
                }
                .padding(.top,10)
                .foregroundColor(.white)
            }
        }
        
    }
}
