//
//  MyAmore.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/29/21.
//

import SwiftUI

struct SubscriptionCardButtons: View {

    @State var width: CGFloat = 0.0
    @State var height: CGFloat = 0.0
    @Binding var popUpCardSelection: PopUpCards
    @Binding var showModal: Bool
    @State var selectionType: PopUpCards = .myAmorecards
    @State var buttonMainText: String = ""
    @State var buttonSubText: String = ""
    @State var buttonColor: [Color] = [Color.pink, Color.orange, Color.pink]
    
    var body : some View {
        
        VStack {
            Button {
                self.showModal.toggle()
                popUpCardSelection = selectionType
            } label: {
                // Amore Gold
                ZStack {
                    capsuleBody
                    VStack {
                        Text(buttonMainText)
                            
                        if buttonSubText != "" {
                            Text(buttonSubText)
                                .font(.caption)
                                .italic()
                        }
                    }
                }
                .foregroundColor(.white)
            }
        }
    }
    
    
    var capsuleBody : some View {
        Capsule()
            .fill(LinearGradient(
                gradient: Gradient(colors: self.buttonColor),
                startPoint: .leading,
                endPoint: .trailing)
            )
            .frame(width:self.width, height: self.height)
    }
}
