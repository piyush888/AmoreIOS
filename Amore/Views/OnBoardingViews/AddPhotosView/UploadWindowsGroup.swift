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
    
    @State var width: CGFloat
    @State var height: CGFloat
    
    var body: some View {
        
        UploadPhotoWindow(profileImage: $profileModel.editUserProfile.image1,
                          photoStruct: $photoModel.photo1,
                          width:width,
                          height:height)
            .environmentObject(photoModel)
            .environmentObject(profileModel)
        
        UploadPhotoWindow(profileImage: $profileModel.editUserProfile.image2,
                          photoStruct: $photoModel.photo2,
                          width:width,
                          height:height)
            .environmentObject(photoModel)
            .environmentObject(profileModel)
        
        UploadPhotoWindow(profileImage: $profileModel.editUserProfile.image3,
                          photoStruct: $photoModel.photo3,
                          width:width,
                          height:height)
            .environmentObject(photoModel)
            .environmentObject(profileModel)
        
        UploadPhotoWindow(profileImage: $profileModel.editUserProfile.image4,
                          photoStruct: $photoModel.photo4,
                          width:width,
                          height:height)
            .environmentObject(photoModel)
            .environmentObject(profileModel)
        
        UploadPhotoWindow(profileImage: $profileModel.editUserProfile.image5,
                          photoStruct: $photoModel.photo5,
                          width:width,
                          height:height)
            .environmentObject(photoModel)
            .environmentObject(profileModel)
        
        UploadPhotoWindow(profileImage: $profileModel.editUserProfile.image6,
                          photoStruct: $photoModel.photo6,
                          width:width,
                          height:height)
            .environmentObject(photoModel)
            .environmentObject(profileModel)
    }
}

struct UploadWindowsGroup_Previews: PreviewProvider {
    
    let adaptivecolumns = Array(repeating:GridItem(.adaptive(minimum: 150),spacing: 5,
                                         alignment: .center),count: 3)
    
    static var previews: some View {
        
        GeometryReader { geo in
            UploadWindowsGroup(width:geo.size.width/3.5, height:geo.size.height/3.5)
                    .environmentObject(PhotoModel())
                    .environmentObject(ProfileViewModel())
        }
    }
}
