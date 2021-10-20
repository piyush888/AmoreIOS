//
//  CardGalleryImages.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/10/21.
//

import SwiftUI

struct CardGalleryImages: View {
    
    @State var deviceWidth: CGFloat
    public var user: User
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            HStack {
                Image(self.user.imageName2)
                        .resizable()
                        .scaledToFill()
                        .frame(width: deviceWidth/2)
                        .clipped()
                    
                Image(self.user.imageName3)
                        .resizable()
                        .scaledToFill()
                        .frame(width: deviceWidth/2)
                        .clipped()
            }
            
            HStack {
                Image(self.user.imageName4)
                    .resizable()
                    .scaledToFill()
                    .frame(width: deviceWidth/3)
                    .clipped()
                
                Image(self.user.imageName5)
                    .resizable()
                    .scaledToFill()
                    .frame(width: deviceWidth/3)
                    .clipped()
                
                Image(self.user.imageName6)
                    .resizable()
                    .scaledToFill()
                    .frame(width: deviceWidth/3)
                    .clipped()
            }
        }
    }
}


