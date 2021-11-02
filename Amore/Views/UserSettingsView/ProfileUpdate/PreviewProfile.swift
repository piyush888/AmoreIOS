//
//  PreviewProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/25/21.
//

import SwiftUI

struct PreviewProfile: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    
                    VStack {
                        Image(uiImage: photoModel.downloadedPhotos.count>0 ? photoModel.downloadedPhotos[0].image! : UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        //.frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                            .clipped()
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
                        
                        
                        // Gallery
                        CardGalleryImages(deviceWidth: (geometry.size.width - 25), image1: photoModel.downloadedPhotos.count>1 ? photoModel.downloadedPhotos[1].image : UIImage(), image2: photoModel.downloadedPhotos.count>2 ? photoModel.downloadedPhotos[2].image : UIImage(), image3: photoModel.downloadedPhotos.count>3 ? photoModel.downloadedPhotos[3].image : UIImage(), image4: photoModel.downloadedPhotos.count>4 ? photoModel.downloadedPhotos[4].image : UIImage(), image5: photoModel.downloadedPhotos.count>5 ? photoModel.downloadedPhotos[5].image : UIImage())
                                .padding(.top,10)
                    }
                    .padding(.horizontal,10)
                }
            }
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 0.1))
        }
        
    }
}

struct PreviewProfile_Previews: PreviewProvider {
    static var previews: some View {
        PreviewProfile()
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
    }
}
