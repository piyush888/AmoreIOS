//
//  SafetyArticleView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 1/11/23.
//

import SwiftUI

struct SafetyCardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let cardSafety: SafetyViewModel
    let maxWidth: Double
    
    // Switch between card color for dark and light mode
    func safetyCardColor()->Gradient {
        if colorScheme == .dark {
            return Gradient(colors: [Color(.systemGray6)])
        } else {
            return Gradient(colors: [Color(hex:0xF2E9FE)])
        }
    }
    
    var body: some View {
        HStack {
            if let image = cardSafety.image {
                Image(systemName:image)
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50.0, height: 50.0)
                    .cornerRadius(5)
                    .padding(9)
                    .strokeStyle(cornerRadius: 16)
                    .foregroundColor(cardSafety.colorScheme ?? Color.primary)
            } else {
                if let illustration = cardSafety.illustration {
                    Image(illustration)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: cardSafety.frameHeight)
                        .cornerRadius(7)
                }
            }
            
            VStack(alignment: .leading) {
                Text(cardSafety.title)
                    .font(.headline)
                
                if cardSafety.body.bound != "" {
                    Text(cardSafety.body.bound)
                        .font(.subheadline)
                }
            }
            
            Spacer()
        }
        .frame(height: cardSafety.frameHeight)
        .frame(maxWidth: maxWidth)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(LinearGradient(
                    gradient: safetyCardColor(),
                    startPoint: .leading,
                    endPoint: .trailing)
                )
                .shadow(radius: 0.5)
        )
    }
}

struct SafetyCardView_Previews: PreviewProvider {
    static var previews: some View {
        SafetyCardView(cardSafety:SafetyViewModel(id:"2",
                                                  image:"shield.fill",
                                                  title:"Safety",
                                                  body:"Keep your community safe & be supportive of other people choices",
                                                  frameHeight:90,
                                                  colorScheme: Color.green),
                       maxWidth:.infinity)
        
        
        SafetyCardView(cardSafety:SafetyViewModel(id:"3",
                                                  illustration: "Dalle1",
                                                  title:"Safety",
                                                  frameHeight:140,
                                                  colorScheme: Color.green),
                       maxWidth:.infinity)
        
    }
}

