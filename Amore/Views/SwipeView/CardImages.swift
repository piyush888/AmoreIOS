//
//  CardImages.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardImages: View {
    
    @State var imageURL: URL?
    @State var imageWidth: CGFloat
    @State var imageHeight: CGFloat
    @State var downsampledImage: UIImage?
    
    func getImage(onFailure: @escaping () -> Void, onSuccess: @escaping (_ image: UIImage) -> Void) {
        SDWebImageManager.shared.loadImage(with: imageURL, options: .continueInBackground, progress: nil) { image, data, error, cacheType, finished, durl in
            if let err = error {
                print(err)
                return
            }
            guard let image = image else {
                // No image handle this error
                onFailure()
                return
            }
            onSuccess(image)
        }
    }
    
    var body: some View {
        VStack {
            Image(uiImage: downsampledImage ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: imageWidth, height:imageHeight/1.5)
                .onAppear(perform: {
                    if downsampledImage == nil {
                        if imageURL != nil {
                            getImage {
                                downsampledImage = nil
                            } onSuccess: { image in
                                downsampledImage = image.downsample(to: CGSize(width: imageWidth, height:imageHeight/1.5))
                            }
                        }
                    }
                })
        }
    }
}

//struct CardImages_Previews: PreviewProvider {
//    static var previews: some View {
//        GeometryReader { geometry in
//            CardImages(imageName:"onboarding_girl4",
//                       imageWidth:geometry.size.width,
//                       imageHeight:geometry.size.height)
//
//        }
//    }
//}
