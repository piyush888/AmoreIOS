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
        UploadPhotoWindow(photoStruct: $photoModel.photosForUploadUpdate[0])
            .environmentObject(photoModel)
        UploadPhotoWindow(photoStruct: $photoModel.photosForUploadUpdate[1]).environmentObject(photoModel)
        UploadPhotoWindow(photoStruct: $photoModel.photosForUploadUpdate[2]).environmentObject(photoModel)
        UploadPhotoWindow(photoStruct: $photoModel.photosForUploadUpdate[3]).environmentObject(photoModel)
        UploadPhotoWindow(photoStruct: $photoModel.photosForUploadUpdate[4]).environmentObject(photoModel)
        UploadPhotoWindow(photoStruct: $photoModel.photosForUploadUpdate[5]).environmentObject(photoModel)
    }
}

struct UploadWindowsGroup_Previews: PreviewProvider {
    static var previews: some View {
        UploadWindowsGroup()
            .environmentObject(PhotoModel())
    }
}
