//
//  CardImages.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI

struct CardImages: View {
    
    @State var imageName: String?
    @State var imageWidth: CGFloat
    @State var imageHeight: CGFloat
    
    var body: some View {
        
        Image(self.imageName ?? "tempImage")
            .resizable()
            .scaledToFill()
            .frame(width: imageWidth, height:imageHeight/1.5)
            .cornerRadius(3.0)
        
    }
}

struct CardImages_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            CardImages(imageName:"onboarding_girl4",
                       imageWidth:geometry.size.width,
                       imageHeight:geometry.size.height)
            
        }
    }
}
