//
//  ShieldButton.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/16/21.
//

import SwiftUI

struct ShieldButton: View {
    @Binding var safetyButton: Bool
    var body: some View {
        
        VStack {
            Button {
                // Store to firebase that the profile is being flagged
                self.safetyButton.toggle()
            } label: {
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.gray, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing)
                    .frame(width:30, height:35)
                    .mask(Image(systemName: "shield.fill")
                            .font(.system(size:25)))
                    .padding(.bottom,20)

            }
        }
        
    }
}

struct ShieldButton_Previews: PreviewProvider {
    static var previews: some View {
        ShieldButton(safetyButton:Binding.constant(false))
    }
}
