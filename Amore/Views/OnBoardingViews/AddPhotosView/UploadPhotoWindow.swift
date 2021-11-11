//
//  UploadPhotoWindow.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/3/21.
//

import SwiftUI
import CropViewController
import Firebase

enum ActiveSheet: Identifiable {
    case imageChoose, cropImage
    var id: Int {
        hashValue
    }
}

struct UploadPhotoWindow: View {
    @Binding var photoStruct: Photo
    @State private var showSheet = false
    @State var activeSheet: ActiveSheet? = .imageChoose
    @State var newPhotoChosen: Bool = false
    @EnvironmentObject var photoModel: PhotoModel

    func imageCropped(image: UIImage){
        self.photoStruct.image = image
        self.photoStruct.downsampledImage = image.downsample(to: CGSize(width: 115, height: 170))
        showSheet = false
        photoStruct.inProgress = true
        photoModel.uploadUpdateSinglePhoto(photo: photoStruct, filename: nil, isUpdate: true) {
            photoStruct.inProgress = false
        }
     }
    
    func onAddPhoto() {
        photoStruct.inProgress = true
        if newPhotoChosen {
            for (index, photo) in photoModel.photosForUploadUpdate.enumerated() {
                if photoStruct.firebaseImagePath == photo.firebaseImagePath && index > photoModel.getPhotosCount()-1 {
                    photoStruct.firebaseImagePath = "images/\(Auth.auth().currentUser?.uid ?? "tempUser")/image\(photoModel.getPhotosCount()).heic"
                }
            }
            print("Uploading new Photo...")
            if let filename = photoStruct.firebaseImagePath?.split(separator: "/").last {
                photoModel.uploadUpdateSinglePhoto(photo: photoStruct, filename: String(filename), isUpdate: true) {
                    photoStruct.inProgress = false
                }
            }
            photoModel.defragmentArray(deleteIndex: nil)
            photoModel.populateIdsForUploadUpdatePhotos()
            newPhotoChosen = false
        }
    }
    
    func onDelete() {
        photoStruct.inProgress = true
        if photoStruct.id == nil {
            photoModel.populateIdsForUploadUpdatePhotos()
        }
        print("Deleting image\(photoStruct.id!)")
        photoModel.deleteMissingPhoto(missing: photoStruct) {
            photoStruct.inProgress = false
        }
        photoModel.clearAllImageCache()
        self.photoStruct.image = nil
        self.photoStruct.downsampledImage = nil
        photoModel.defragmentArray(deleteIndex: Int(self.photoStruct.id!))
        photoModel.populateIdsForUploadUpdatePhotos()
    }

    var body: some View {
        
        if !(photoStruct.inProgress ?? false) {
            VStack {
                
                if photoStruct.image != nil {
                    Image(uiImage: photoStruct.downsampledImage ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 115, height: 170, alignment: .center)
                        .clipped()
                        .cornerRadius(5.0)
                        .background(Color.pink.opacity(0.2))
                        .shadow(color: Color("onboarding-pink"),
                                radius: 2, x: 3, y: 3)
                        .clipShape(Rectangle())
                } else {
                    Image(uiImage: UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 115, height: 170, alignment: .center)
                        .clipped()
                        .cornerRadius(5.0)
                        .background(Color.pink.opacity(0.2))
                        .shadow(color: Color("onboarding-pink"),
                                radius: 2, x: 3, y: 3)
                        .clipShape(Rectangle())
                }
                
            
               HStack {
                    Image(systemName:"plus.circle.fill")
                        .resizable()
                        .frame(width:20, height:20)
                        .foregroundColor(.green)
                        .onTapGesture {
                            showSheet = true
                            activeSheet = .imageChoose
                        }
                    
                    // Don't show if the image is nil
                   if photoStruct.image != nil && photoStruct.firebaseImagePath != nil {
                        Image(systemName:"pencil.circle.fill")
                            .resizable()
                            .frame(width:20, height:20)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showSheet = true
                                activeSheet = .cropImage
                            }
                       if photoModel.getPhotosCount() > 2{
                           Image(systemName:"trash.circle.fill")
                               .resizable()
                               .frame(width:20, height:20)
                               .foregroundColor(.red)
                               .onTapGesture {
                                   onDelete()
                               }
                       }
                    }
                }
                
            }.sheet(isPresented: $showSheet) {
                if self.activeSheet == .imageChoose {
                    // Pick an image from the photo library:
                    // If you wish to take a photo from camera instead:
                    // ImagePicker(sourceType: .camera, selectedImage: self.$image)
                    ImagePicker(sourceType: .photoLibrary, selectedPhoto: $photoStruct, newPhotoChosen: $newPhotoChosen, done: onAddPhoto)
                }
                else if self.activeSheet == .cropImage {
                    // Option to Crop the image
                    ImageCropper(image: self.$photoStruct.image, visible: self.$showSheet, done: self.imageCropped)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
        else {
            ProgressView()
                .scaledToFill()
                .frame(width: 115, height: 170, alignment: .center)
                .clipped()
                .cornerRadius(5.0)
                .background(Color.pink.opacity(0.2))
                .shadow(color: Color("onboarding-pink"),
                        radius: 2, x: 3, y: 3)
                .clipShape(Rectangle())
        }
        
    }
}

struct UploadPhotoWindow_Previews: PreviewProvider {
    static var previews: some View {
        UploadPhotoWindow(photoStruct: Binding.constant(Photo()))
    }
}
