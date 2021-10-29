//
//  CardGalleryImages.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/10/21.
//

import SwiftUI

struct CardGalleryImages: View {
    
    @State var deviceWidth: CGFloat
    @State var image1: UIImage?
    @State var image2: UIImage?
    @State var image3: UIImage?
    @State var image4: UIImage?
    @State var image5: UIImage?
    @State var user: User?
    
    var body: some View {
        if user != nil{
            VStack(alignment:.leading) {
                
                HStack {
                    Image(user?.imageName1 ?? "tempImage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: deviceWidth/2)
                            .clipped()
                        
                    Image(user?.imageName2 ?? "tempImage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: deviceWidth/2)
                            .clipped()
                }
                
                HStack {
                    Image(user?.imageName3 ?? "tempImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: deviceWidth/3)
                        .clipped()
                    
                    Image(user?.imageName4 ?? "tempImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: deviceWidth/3)
                        .clipped()
                    
                    Image(user?.imageName5 ?? "tempImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: deviceWidth/3)
                        .clipped()
                }
            }
        }
        else {
            VStack(alignment:.leading) {
                
                HStack {
                    Image(uiImage: image1 ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: deviceWidth/2)
                            .clipped()
                        
                    Image(uiImage: image2 ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: deviceWidth/2)
                            .clipped()
                }
                
                HStack {
                    Image(uiImage: image3 ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: deviceWidth/3)
                        .clipped()
                    
                    Image(uiImage: image4 ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: deviceWidth/3)
                        .clipped()
                    
                    Image(uiImage: image5 ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: deviceWidth/3)
                        .clipped()
                }
            }
        }
        
    }
}


