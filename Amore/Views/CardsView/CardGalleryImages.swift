//
//  CardGalleryImages.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/10/21.
//

import SwiftUI

struct CardGalleryImages: View {
    
    @State var deviceWidth: CGFloat
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            Text("Gallery")
                .font(.BoardingTitle2)
            
            HStack {
                    Image("image2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: deviceWidth/2)
                        .clipped()
                    
                    Image("image3")
                        .resizable()
                        .scaledToFill()
                        .frame(width: deviceWidth/2)
                        .clipped()
            }
            
            HStack {
                Image("image4")
                    .resizable()
                    .scaledToFill()
                    .frame(width: deviceWidth/3)
                    .clipped()
                
                Image("image5")
                    .resizable()
                    .scaledToFill()
                    .frame(width: deviceWidth/3)
                    .clipped()
                
                Image("image6")
                    .resizable()
                    .scaledToFill()
                    .frame(width: deviceWidth/3)
                    .clipped()
            }
        }
    }
}


