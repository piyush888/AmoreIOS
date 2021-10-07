//
//  TestView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/6/21.
//

import SwiftUI

struct PhotosViewCarousel: View {
    @State var index = 0

    var images = ["image1", "image2", "image3", "image4"]

    var body: some View {
        VStack {
            
            PagingView(index: $index.animation(), maxIndex: images.count - 1) {
                ForEach(self.images, id: \.self) { imageName in
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                }
            }
            .aspectRatio(3/4, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 15))

//            Stepper("Index: \(index)", value: $index.animation(.easeInOut), in: 0...images.count-1)
//                .font(Font.body.monospacedDigit())
        }
        .padding()
    }
}
