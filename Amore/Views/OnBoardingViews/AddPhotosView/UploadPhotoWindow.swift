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
    
    @State var width: CGFloat
    @State var height: CGFloat
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    
    func imageCropped(image: UIImage){
        self.photoStruct.image = image
        self.photoStruct.downsampledImage = image.downsample(to: CGSize(width: width, height: height))
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
            //            photoStruct = Photo()
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
                //                photoStruct = Photo()
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
            //            photoStruct = Photo(image: nil, downsampledImage: nil, inProgress: true)
            photoStruct.image = nil
            photoStruct.downsampledImage = nil
            profileModel.defragmentProfileImagesArray()
            profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid)
        }
    }
    
    func getImage() {
        SDWebImageManager.shared.loadImage(with: profileImage?.imageURL, options: .continueInBackground, progress: nil) { image, data, error, cacheType, finished, durl in
            if let err = error {
                print("Error while loading image UploadPhotoWindow: \(err)")
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
            /// While downloading photos, if image data is greater than 1 MB, compress to HEIC data and then store image
            if Double(NSData(data: try! image.heicData(compressionQuality: 1)).count) / 1000.0 > 1000.0 {
                let compressed = try! image.heicData(compressionQuality: 0.6)
                photoStruct.image = UIImage(data: compressed)
            }
            else {
                photoStruct.image = image
            }
            
            let heightInPoints = photoStruct.image?.size.height
            let widthInPoints = photoStruct.image?.size.width
            
            photoStruct.downsampledImage = image.downsample(to: CGSize(width: (widthInPoints ?? 2000)/10, height: heightInPoints ?? 3000/10))
            
            if finished {
                photoModel.photoAction = false
                SDImageCache.shared.removeImage(forKey: profileImage?.imageURL!.absoluteString) {
                    //                    print("Successfully deleted self profile image cache")
                }
            }
        }
    }
    
    var body: some View {
        
        
        VStack {
            
            if photoStruct.downsampledImage != nil {
                editAvailablePhoto
            } else {
                addANewPhoto
            }
        }
        .onAppear(perform: {
            if photoStruct.downsampledImage == nil {
                if profileImage?.imageURL != nil {
                    getImage()
                }
            }
            else {
                if profileImage?.imageURL == nil {
                    photoStruct = Photo()
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
                print("On Change: Upload Photo Window")
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
                // Use the non-downsampled/original image for cropping.
                ImageCropper(image: self.$photoStruct.image, visible: self.$showSheet, done: self.imageCropped)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    // When a photo is already available and user wants to edit the photo
    var editAvailablePhoto: some View {
        Menu {
            Button("Change Photo") {
                showSheet = true
                activeSheet = .imageChoose
            }
            
            if photoStruct.downsampledImage != nil {
                Button("Edit Photo") {
                    showSheet = true
                    activeSheet = .cropImage
                }
                
                if profileModel.numOfUserPhotosAdded() > 2 {
                    Button("Delete Photo") {
                        onDelete()
                    }
                }
            }
        } label: {
            ZStack(alignment: .bottomTrailing) {
                Image(uiImage: photoStruct.downsampledImage ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height, alignment: .center)
                    .cornerRadius(10.0)
                    .clipped()
                
                Image(systemName:"pencil.circle")
                          .resizable()
                          .frame(width:20, height:20)
                          .foregroundColor(.white)
                          .padding(10)
            }
            
        }
    }
    
    
    // When user wants to add a new photo
    var addANewPhoto: some View {
        Menu {
            Button("Add Photo") {
                showSheet = true
                activeSheet = .imageChoose
            }
        } label: {
            ZStack {
                Image(uiImage: UIImage())
                    .frame(width: width, height: height, alignment: .center)
                    .background(colorScheme == .dark ? Color(hex: 0x24244A): Color(hex: 0xe8f4f8))
                    .cornerRadius(10.0)
                    .clipped()
                
                Image(systemName:"plus.circle")
                    .resizable()
                    .frame(width:25, height:25)
            }
        }
    }
    
}

struct UploadPhotoWindow_Previews: PreviewProvider {
    static var previews: some View {
        UploadPhotoWindow(profileImage: Binding.constant(ProfileImage()),
                          photoStruct: Binding.constant(Photo()),
                          width:110,
                          height:170)
    }
}
