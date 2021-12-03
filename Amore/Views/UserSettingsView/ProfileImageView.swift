//
//  ProfileImageView.swift
//  Amore
//
//  Created by Piyush Garg on 17/11/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileImageView<V>: View where V: ViewModifier {
    
    @Binding var profileImage: ProfileImage?
    @Binding var photo: Photo
    var customModifier: V
    
    func getImage(onFailure: @escaping () -> Void, onSuccess: @escaping (_ image: UIImage) -> Void) {
        SDWebImageManager.shared.loadImage(with: profileImage?.imageURL, options: .continueInBackground, progress: nil) { image, data, error, cacheType, finished, durl in
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
            if finished {
                SDImageCache.shared.removeImage(forKey: profileImage?.imageURL!.absoluteString) {
                    print("Successfully deleted some image cache")
                }
            }
        }
    }
    
    var body: some View {
        
        Image(uiImage: photo.downsampledImage ?? UIImage())
            .resizable()
            .modifier(customModifier)
            .onAppear(perform: {
                if photo.image == nil {
                    if profileImage?.imageURL != nil {
                        getImage {
                            photo.image = nil
                            photo.downsampledImage = nil
                        } onSuccess: { image in
//                            photo.image = image
                            photo.downsampledImage = image.downsample(to: CGSize(width: 115, height: 170))
                        }
                    }
                }
            })
            .onChange(of: profileImage?.imageURL) { newValue in
                getImage {
                    photo.image = nil
                    photo.downsampledImage = nil
                } onSuccess: { image in
//                    photo.image = image
                    photo.downsampledImage = image.downsample(to: CGSize(width: 115, height: 170))
                }
            }
    }
}

