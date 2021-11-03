//
//  UploadWindowsGroup.swift
//  Amore
//
//  Created by Piyush Garg on 03/11/21.
//

import SwiftUI

struct UploadWindowsGroup: View {
    
    @EnvironmentObject var photoModel: PhotoModel
        
    var body: some View {
        UploadPhotoWindow(photoStruct: photoModel.photosForUploadUpdate.count>0 ? $photoModel.photosForUploadUpdate[0] : Binding.constant(Photo()))
        UploadPhotoWindow(photoStruct: photoModel.photosForUploadUpdate.count>1 ? $photoModel.photosForUploadUpdate[1] : Binding.constant(Photo()))
        UploadPhotoWindow(photoStruct: photoModel.photosForUploadUpdate.count>2 ? $photoModel.photosForUploadUpdate[2] : Binding.constant(Photo()))
        UploadPhotoWindow(photoStruct: photoModel.photosForUploadUpdate.count>3 ? $photoModel.photosForUploadUpdate[3] : Binding.constant(Photo()))
        UploadPhotoWindow(photoStruct: photoModel.photosForUploadUpdate.count>4 ? $photoModel.photosForUploadUpdate[4] : Binding.constant(Photo()))
        UploadPhotoWindow(photoStruct: photoModel.photosForUploadUpdate.count>5 ? $photoModel.photosForUploadUpdate[5] : Binding.constant(Photo()))
    }
}

struct UploadWindowsGroup_Previews: PreviewProvider {
    static var previews: some View {
        UploadWindowsGroup()
            .environmentObject(PhotoModel())
    }
}
