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
    
    
    func getImage(imageURL: URL, onFailure: @escaping () -> Void, onSuccess: @escaping (_ image: UIImage) -> Void) {
        SDWebImageManager.shared.loadImage(with: imageURL, options: [.continueInBackground], progress: nil) { image, data, error, cacheType, finished, durl in
            if let err = error {
                print(err)
                return
            }
            guard let image = image else {
                // No image handle this error
                onFailure()
                return
            }
            if finished {
                onSuccess(image)
            }

        }
    }
    
    var body: some View {
        VStack {
            Image(uiImage: photoStruct.downsampledImage ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: imageWidth, height:imageHeight/1.5)
                .onAppear {
                    if photoStruct.downsampledImage == nil {
                        if let imageURL = profileImage?.imageURL {
                            getImage(imageURL: imageURL) {
                                return
                            } onSuccess: { downloadedImage in
                                photoStruct = Photo(image: nil, downsampledImage: downloadedImage.downsample(to: CGSize(width: self.imageWidth, height: self.imageHeight/1.5)), inProgress: false)
//                                SDImageCache.shared.removeImage(forKey: imageURL.absoluteString) {
//                                    print("Successfully deleted")
//                                }
                            }
                        }
                    }
                }
            //                .onDisappear{
            //                    SDImageCache.shared.removeImage(forKey: imageURL?.absoluteString) {
            //                        print("Successfully deleted")
            //                    }
            //                }
        }
    }
}

