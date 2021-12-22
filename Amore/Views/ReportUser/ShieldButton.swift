//
//  ShieldButton.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/16/21.
//

import SwiftUI

struct ShieldButton: View {
    
    @Binding var safetyButton: Bool
    @State var buttonWidth: CGFloat
    @State var buttonHeight: CGFloat
    @State var fontSize: CGFloat
    @State var shieldColorList: [Color]
    
    var body: some View {
        
        VStack {
            Button {
                // Store to firebase that the profile is being flagged
                self.safetyButton.toggle()
            } label: {
                
                LinearGradient(
                    gradient: Gradient(colors: shieldColorList),
                    startPoint: .leading,
                    endPoint: .trailing)
                    .frame(width:buttonWidth, height:buttonHeight)
                    .mask(Image(systemName: "shield.fill")
                            .font(.system(size:fontSize)))
                    .padding(.bottom,20)

            }
        }
        
    }
}

struct ShieldButton_Previews: PreviewProvider {
    static var previews: some View {
        ShieldButton(safetyButton:Binding.constant(false),
                     buttonWidth:30,
                     buttonHeight: 35,
                     fontSize:25,
                     shieldColorList:[Color.purple,Color.red])
    }
}
