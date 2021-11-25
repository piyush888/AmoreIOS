//
//  CardImages.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardImages: View {
    
    @Binding var profileImage: ProfileImage?
    @Binding var photoStruct: Photo
    @State var imageWidth: CGFloat
    @State var imageHeight: CGFloat
    
    var body: some View {
        VStack {
            Image(uiImage: photoStruct.downsampledImage ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: imageWidth, height:imageHeight/1.5)
        }
    }
}

