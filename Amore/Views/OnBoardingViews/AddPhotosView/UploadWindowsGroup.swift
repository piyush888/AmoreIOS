//
//  UploadWindowsGroup.swift
//  Amore
//
//  Created by Piyush Garg on 03/11/21.
//

import SwiftUI

struct UploadWindowsGroup: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
        
    var body: some View {
        UploadPhotoWindow(profileImage: $profileModel.editUserProfile.image1, photoStruct: $photoModel.photo1)
            .environmentObject(photoModel)
            .environmentObject(profileModel)
        UploadPhotoWindow(profileImage: $profileModel.editUserProfile.image2, photoStruct: $photoModel.photo2)
            .environmentObject(photoModel)
            .environmentObject(profileModel)
        UploadPhotoWindow(profileImage: $profileModel.editUserProfile.image3, photoStruct: $photoModel.photo3)
            .environmentObject(photoModel)
            .environmentObject(profileModel)
        UploadPhotoWindow(profileImage: $profileModel.editUserProfile.image4, photoStruct: $photoModel.photo4)
            .environmentObject(photoModel)
            .environmentObject(profileModel)
        UploadPhotoWindow(profileImage: $profileModel.editUserProfile.image5, photoStruct: $photoModel.photo5)
            .environmentObject(photoModel)
            .environmentObject(profileModel)
        UploadPhotoWindow(profileImage: $profileModel.editUserProfile.image6, photoStruct: $photoModel.photo6)
            .environmentObject(photoModel)
            .environmentObject(profileModel)
    }
}

struct UploadWindowsGroup_Previews: PreviewProvider {
    static var previews: some View {
        UploadWindowsGroup()
            .environmentObject(PhotoModel())
    }
}
