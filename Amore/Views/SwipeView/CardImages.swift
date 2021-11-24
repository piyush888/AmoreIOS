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
    
    func getImage(onFailure: @escaping () -> Void, onSuccess: @escaping (_ image: UIImage) -> Void) {
        SDWebImageManager.shared.loadImage(with: profileImage?.imageURL, options: [.continueInBackground], progress: nil) { image, data, error, cacheType, finished, durl in
            if let err = error {
                print(err)
                return
            }
            guard let image = image else {
                // No image handle this error
                onFailure()
                return
            }
            photoStruct = Photo(image: nil, downsampledImage: image.downsample(to: CGSize(width: imageWidth, height:imageHeight/1.5)), inProgress: false)
            photoStruct.downsampledImage = image.downsample(to: CGSize(width: imageWidth, height:imageHeight/1.5))
            onSuccess(image)
        }
    }
    
    var body: some View {
        VStack {
            Image(uiImage: photoStruct.downsampledImage ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: imageWidth, height:imageHeight/1.5)
                .onAppear(perform: {
                    if profileImage?.imageURL != nil {
                        getImage {
//                            photoStruct = Photo()
                        } onSuccess: { image in
//                            photoStruct.downsampledImage = image.downsample(to: CGSize(width: imageWidth, height:imageHeight/1.5))
//                            photoStruct = Photo(image: nil, downsampledImage: image.downsample(to: CGSize(width: imageWidth, height:imageHeight/1.5)), inProgress: false)
//                            SDImageCache.shared.clearMemory()
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
