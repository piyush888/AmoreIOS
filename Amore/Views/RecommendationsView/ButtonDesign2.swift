//
//  ButtonDesign2.swift
//  Amore
//
//  Created by Kshitiz Sharma on 5/8/23.
//

import SwiftUI

struct ButtonDesign2: View {
    
    @State var buttonActive:Bool
    
    let fontSize: CGFloat =  20
    
    var body: some View {
        
        HStack(spacing:10) {
            
            Image(systemName: buttonActive ? "bolt.circle.fill" : "bolt.fill")
                .font(.system(size: fontSize))
                .foregroundColor(Color.blue)

            Spacer()
            Image(systemName: buttonActive ? "slider.vertical.3": "slider.vertical.3")
                .font(.system(size: fontSize))
                .foregroundColor(Color.purple)
            Spacer()
            // All the 10 profiles in the deck
            Image(systemName: buttonActive ? "arrow.clockwise": "arrow.clockwise")
                .font(.system(size: fontSize))
                .foregroundColor(Color.purple)
            Spacer()
            // We keep how many proposals a persona can send in a day
            
            HStack(spacing: 0) {
                Image(systemName: buttonActive ? "bird.fill": "bird")
                    .font(.system(size: 25))
                    .foregroundColor(Color.purple)
                    .padding(.trailing, -5)
                Text("3")
                    .foregroundColor(Color.purple)
                    .padding(.leading, 5)
            }
            
        }
        .padding(.horizontal,10)
        
    }
}

struct ButtonDesign2_Previews: PreviewProvider {
    static var previews: some View {
        ButtonDesign2(buttonActive:true)
        ButtonDesign2(buttonActive:false)
    }
}
