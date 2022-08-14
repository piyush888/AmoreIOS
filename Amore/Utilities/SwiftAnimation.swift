//
//  SwiftAnimation.swift
//  Amore
//
//  Created by Kshitiz Sharma on 8/14/22.
//

import SwiftUI


struct SwiftAnimation: View {
    
    @State var animationImageName: String = "heart.circle"
    @State var animationSize: CGFloat = 80
    @State var animationColor: Color = Color.red
    @State var angleOfRotation: CGFloat = 0.0
    
    var body: some View {
        Image(systemName: self.animationImageName)
            .resizable()
            .frame(width:animationSize, height:animationSize)
            .foregroundColor(animationColor)
            .rotationEffect(.degrees(angleOfRotation))
    }
}



struct SwiftAnimation_Previews: PreviewProvider {
    
    static var previews: some View {
        SwiftAnimation(animationImageName:"heart.circle",
                       animationSize:100,
                       animationColor:Color.red,
                       angleOfRotation:30)
        
        SwiftAnimation(animationImageName:"heart.slash.circle",
                       animationSize:100,
                       animationColor:Color.green,
                       angleOfRotation:-30)
    }
    
}
