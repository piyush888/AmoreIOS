//
//  LikeDislikeButtons.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/13/21.
//

import SwiftUI

struct LikeDislikeButtons: View {
    
    @State var buttonName: String
    @State var buttonColor: Color
    @State var rotationAngle: Double
    @State var imageName: String
    
    var body: some View {
        Group {
            
                HStack {
                    Text(buttonName)
                    Image(systemName: imageName)
                }
                .font(.title)
                .padding()
                .cornerRadius(10)
                .foregroundColor(buttonColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(buttonColor, lineWidth: 3.0)
                )
                .shadow(color: buttonColor, radius: 14, x: 14, y: 14)
                .padding(.top, 45)
                .rotationEffect(Angle.degrees(rotationAngle))
        }
    }
}

struct LikeDislikeButtons_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LikeDislikeButtons(buttonName: "Like", buttonColor: Color.green, rotationAngle: 45, imageName: "bolt.heart.fill")
            LikeDislikeButtons(buttonName: "DisLike", buttonColor: Color.red, rotationAngle: -45, imageName: "heart.slash.fill")
        }
    }
}
