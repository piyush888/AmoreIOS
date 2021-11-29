//
//  UploadPhotoWindow.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/3/21.
//

import SwiftUI
import CropViewController
import Firebase
import SDWebImageSwiftUI

enum ActiveSheet: Identifiable {
    case imageChoose, cropImage
    var id: Int {
        hashValue
    }
}

struct UploadPhotoWindow: View {
    @Binding var profileImage: ProfileImage?
    @Binding var photoStruct: Photo
    @State private var showSheet = false
    @State var activeSheet: ActiveSheet? = .imageChoose
    @State var newPhotoChosen: Bool = false
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    
    func imageCropped(image: UIImage){
        self.photoStruct.image = image
        self.photoStruct.downsampledImage = image.downsample(to: CGSize(width: 115, height: 170))
        showSheet = false
        var oldImagePath = ""
        photoModel.photoAction = true
        photoStruct.inProgress = true
        if profileImage?.firebaseImagePath != nil {
            oldImagePath = (profileImage?.firebaseImagePath)!
        }
        photoModel.uploadSinglePhoto(photo: &photoStruct) { url, imagePath in
            profileImage?.imageURL = url
            profileImage?.firebaseImagePath = imagePath
            profileModel.defragmentProfileImagesArray()
            profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid)
        } onFinish: {
            photoStruct.image = nil
            photoStruct.downsampledImage = nil
            photoStruct.inProgress = false
        }
        if oldImagePath != "" {
            photoModel.deletePhotoByPath(path: oldImagePath)
        }
    }
    
    func onAddPhoto() {
        if newPhotoChosen {
            var oldImagePath = ""
            photoModel.photoAction = true
            photoStruct.inProgress = true
            if profileImage?.firebaseImagePath != nil {
                oldImagePath = (profileImage?.firebaseImagePath)!
            }
            photoModel.uploadSinglePhoto(photo: &photoStruct) { url, imagePath in
                profileImage?.imageURL = url
                profileImage?.firebaseImagePath = imagePath
                profileModel.defragmentProfileImagesArray()
                profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid)
            } onFinish: {
                photoStruct.image = nil
                photoStruct.downsampledImage = nil
                photoStruct.inProgress = false
            }
            newPhotoChosen = false
            if oldImagePath != "" {
                print("DELETING OLD PHOTO...\(oldImagePath)")
                photoModel.deletePhotoByPath(path: oldImagePath)
            }
        }
    }
    
    func onDelete() {
        photoModel.photoAction = true
        photoStruct.inProgress = true
        photoModel.deleteTriggered = true
        photoModel.deleteSinglePhoto(profileImage: profileImage ?? ProfileImage()) {
            photoStruct.inProgress = false
            photoModel.photoAction = false
        } onSuccess: {
            profileImage?.imageURL = nil
            profileImage?.firebaseImagePath = nil
            photoStruct.image = nil
            photoStruct.downsampledImage = nil
            profileModel.defragmentProfileImagesArray()
            profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid)
        }
    }
    
    func getImage() {
        SDWebImageManager.shared.loadImage(with: profileImage?.imageURL, options: .continueInBackground, progress: nil) { image, data, error, cacheType, finished, durl in
            if let err = error {
                print(err)
                photoModel.photoAction = false
                return
            }
            guard let image = image else {
                // No image handle this error
                photoStruct.image = nil
                photoStruct.downsampledImage = nil
                photoModel.photoAction = false
                return
            }
            photoStruct.image = image
            photoStruct.downsampledImage = image.downsample(to: CGSize(width: 115, height: 170))
            
            if finished {
                print("FINISHED LOADING IMAGE...")
                photoModel.photoAction = false
                SDImageCache.shared.removeImage(forKey: profileImage?.imageURL!.absoluteString) {
                    print("Successfully deleted")
                }
            }
        }
    }
    
    var body: some View {
        
        
        VStack {
            
            if photoStruct.image != nil {
                Image(uiImage: photoStruct.downsampledImage ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 115, height: 170, alignment: .center)
                    .cornerRadius(10.0)
                    .clipped()
            } else {
                Image(uiImage: UIImage())
                    .frame(width: 115, height: 170, alignment: .center)
                    .background(Color.pink.opacity(0.2))
                    .cornerRadius(10.0)
                    .clipped()
            }
            
            
            HStack {
                Image(systemName:"plus.circle")
                    .resizable()
                    .frame(width:20, height:20)
                    .foregroundColor(.green)
                    .onTapGesture {
                        showSheet = true
                        activeSheet = .imageChoose
                    }
                
                // Don't show if the image is nil
                if photoStruct.image != nil {
                    Image(systemName:"pencil.circle")
                        .resizable()
                        .frame(width:20, height:20)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showSheet = true
                            activeSheet = .cropImage
                        }
                    if profileModel.numOfUserPhotosAdded() > 2 {
                        Image(systemName:"trash.circle")
                            .resizable()
                            .frame(width:20, height:20)
                            .foregroundColor(.red)
                            .onTapGesture {
                                onDelete()
                            }
                    }
                    
                }
            }
            
        }
        .onAppear(perform: {
            if photoStruct.image == nil {
                if profileImage?.imageURL != nil {
                    getImage()
                }
            }
        })
        .onChange(of: profileImage?.imageURL, perform: { newURL in
            if photoModel.deleteTriggered {
                photoStruct.image = nil
                photoStruct.downsampledImage = nil
                photoModel.deleteTriggered = false
            }
            if profileImage?.imageURL != nil {
                getImage()
            }
            
        })
        .sheet(isPresented: $showSheet) {
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
}

struct UploadPhotoWindow_Previews: PreviewProvider {
    static var previews: some View {
        UploadPhotoWindow(profileImage: Binding.constant(ProfileImage()), photoStruct: Binding.constant(Photo()))
    }
}
