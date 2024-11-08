//
//  ButtonIcon.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/16/21.
//

import SwiftUI

struct ButtonIcon: View {
    
    @Binding var allcardsActiveSheet: AllCardsActiveSheet?
    @State var buttonWidth: CGFloat
    @State var buttonHeight: CGFloat
    @State var fontSize: CGFloat
    @State var colorList: [Color]
    @State var viewToBeAssigned: AllCardsActiveSheet?
    @State var iconName: String
    
    var body: some View {
        
        VStack {
            Button {
                self.allcardsActiveSheet = viewToBeAssigned
            } label: {
                LinearGradient(
                    gradient: Gradient(colors: colorList),
                    startPoint: .leading,
                    endPoint: .trailing)
                    .frame(width:buttonWidth, height:buttonHeight)
                    .mask(Image(systemName: iconName)
                            .font(.system(size:fontSize)))
                    .padding(.bottom,20)

            }
        }
        
    }
}

