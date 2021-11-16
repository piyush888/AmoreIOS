//
//  UserSnapDetails.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/30/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserSnapDetails: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var photoModel: PhotoModel
    
    func getImage(onFailure: @escaping () -> Void, onSuccess: @escaping (_ image: UIImage) -> Void) {
        SDWebImageManager.shared.loadImage(with: profileModel.editUserProfile.image1?.imageURL, options: .continueInBackground, progress: nil) { image, data, error, cacheType, finished, durl in
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
            Image(uiImage: photoModel.photo1.image ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200, alignment: .center)
                .clipShape(Circle())
                .shadow(color: Color.pink, radius: 5, x: 0.5, y: 0.5)
                .onAppear(perform: {
                    if photoModel.photo1.image == nil {
                        if profileModel.editUserProfile.image1?.imageURL != nil {
                            getImage {
                                photoModel.photo1.image = nil
                                photoModel.photo1.downsampledImage = nil
                            } onSuccess: { image in
                                photoModel.photo1.image = image
                                photoModel.photo1.downsampledImage = image.downsample(to: CGSize(width: 115, height: 170))
                            }
                        }
                    }
                })
                .onChange(of: profileModel.editUserProfile.image1?.imageURL) { newValue in
                    getImage {
                        photoModel.photo1.image = nil
                        photoModel.photo1.downsampledImage = nil
                    } onSuccess: { image in
                        photoModel.photo1.image = image
                        photoModel.photo1.downsampledImage = image.downsample(to: CGSize(width: 115, height: 170))
                    }
                }
            
            Text("\(profileModel.editUserProfile.firstName ?? "Kshitiz"), \(profileModel.editUserProfile.age ?? 25)")
                .font(.title2)
            
            Text("\(profileModel.editUserProfile.jobTitle ?? "Software Developer") at \(profileModel.editUserProfile.work ?? "Amore")")
                .font(.caption)
            
            Text("Attended \(profileModel.editUserProfile.school ?? "Brightlands School")")
                .font(.caption)
            
            Spacer()
        }.padding(.top,50)
        
    }
}

struct UserSnapDetails_Previews: PreviewProvider {
    static var previews: some View {
        UserSnapDetails()
    }
}
