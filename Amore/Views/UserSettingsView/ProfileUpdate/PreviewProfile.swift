//
//  PreviewProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/25/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct PreviewProfile: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    
    
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
        
        
        GeometryReader { geometry in
            
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    
                    VStack {
                        Image(uiImage: photoModel.photo1.image ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        //.frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                            .clipped()
                    }
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
                    
                    VStack {
                        // Profile Names and age
                        // Profile Bio
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(profileModel.editUserProfile.firstName.bound) \(profileModel.editUserProfile.lastName.bound), \(profileModel.editUserProfile.age ?? 25)")
                                    .font(.title2)
                                    .bold()
                                Text(profileModel.editUserProfile.description.bound)
                                    .font(.subheadline)
                                
                                // User Location and distance
                                ZStack {
                                    HStack {
                                        Image(systemName: "mappin.and.ellipse")
                                            .resizable()
                                            .frame(width:20, height:20)
                                            .foregroundColor(.black)
                                        
                                        Text("\(profileModel.editUserProfile.profileDistanceFromUser ?? 2) km away")
                                            .foregroundColor(.black)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            Spacer()
                        }
                        
                        
                        // Profile Height, Education, Job, Religion, Location
                        CardBasicInfo(height: profileModel.editUserProfile.height.bound,
                                      work: profileModel.editUserProfile.work.bound,
                                      education: profileModel.editUserProfile.education.bound,
                                      religion: profileModel.editUserProfile.religion.bound,
                                      politics: profileModel.editUserProfile.politics.bound,
                                      location: profileModel.editUserProfile.location.bound)
                            .padding(.top,10)
                        
                        
                        // Profile Passions
                        CardPassions(passions: profileModel.editUserProfile.interests ?? ["tempPassion"])
                            .padding(.top,10)
                        
                    }
                    .padding(.horizontal,10)
                }
            }
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 0.1))
        }
        .padding(.horizontal,20)
    }
}

struct PreviewProfile_Previews: PreviewProvider {
    static var previews: some View {
        PreviewProfile()
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
    }
}
