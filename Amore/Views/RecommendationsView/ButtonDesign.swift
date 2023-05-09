//
//  ButtonDesign.swift
//  Amore
//
//  Created by Kshitiz Sharma on 5/7/23.
//

import SwiftUI

struct ButtonDesign: View {
    
    @State var buttonActive:Bool
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                VStack(spacing:5) {
                    
                    Image(systemName: buttonActive ? "heart.fill" : "heart")
                        .renderingMode(.original)
                        .font(.system(size: 30))
                        .foregroundColor(Color.red)
                        
                    Image(systemName: buttonActive ? "heart.slash.fill" : "heart.slash")
                        .renderingMode(.original)
                        .font(.system(size: 30))
                        .foregroundColor(Color.gray)
                    
//                    Image(systemName: "star.fill")
//                        .renderingMode(.original)
//                        .font(.system(size: 30))
//                        .foregroundColor(buttonActive ? Color("gold-star"): Color.black)
                    
                    Image(systemName: buttonActive ? "timer.fill": "timer")
                        .renderingMode(.original)
                        .font(.system(size: 30))
                        .foregroundColor(Color.black)
                        
                    Image(systemName: buttonActive ? "message.fill": "message")
                        .renderingMode(.original)
                        .font(.system(size: 30))
                        .foregroundColor(Color.blue)
                    
                    Image(systemName: buttonActive ? "shield.fill" : "shield")
                        .renderingMode(.original)
                        .font(.system(size: 30))
                        .foregroundColor(Color.red)
                    
                    
                }
            }
            .padding(.trailing,4)
        }
        
    }
}

struct ButtonDesign_Previews: PreviewProvider {
    static var previews: some View {
        ButtonDesign(buttonActive:false)
        ButtonDesign(buttonActive:true)
    }
    
}
