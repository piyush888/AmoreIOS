//
//  PhotoModel.swift
//  Amore
//
//  Created by Piyush Garg on 20/10/21.
//

import Foundation
import Firebase
import UIKit
import SDWebImageSwiftUI

class PhotoModel: ObservableObject {
    
    @Published var downloadedPhotosURLs = [DownloadedPhotoURL]()
    @Published var downloadedPhotos = [Photo]()
    @Published var photosForUploadUpdate = [Photo](repeating: Photo(), count: 6)
    @Published var minUserPhotosAdded = false
    
    @Published var photosFetchedAndReady: Bool = false
    let storage = Storage.storage()
    
    /// Removes empty frames between photos
    func defragmentArray(deleteIndex: Int?) {
        var newArray = photosForUploadUpdate
        newArray.removeAll { photo in
            if photo.image == nil {
                return true
            }
            else {
                return false
            }
        }
        if let deleteIndex = deleteIndex {
            /// Delete the photos placed after the photo being deleted and re-upload them with rectified names and firebase storage paths
            for missing in newArray[deleteIndex...] {
                self.deleteMissingPhoto(missing: missing) {
                    return
                }
            }
            for index in deleteIndex..<newArray.count {
                if newArray[index].firebaseImagePath != nil {
                    newArray[index].firebaseImagePath = "images/\(Auth.auth().currentUser?.uid ?? "tempUser")/image\(index+1).heic"
                }
            }
            self.uploadUpdateMultiplePhotos(photos: newArray[deleteIndex...])
        }
        for _ in 0..<(6-newArray.count) {
            newArray.append(Photo())
        }
        for index in 0..<newArray.count {
            newArray[index].id = String(index)
        }
        photosForUploadUpdate = newArray
    }
    
    /// Get current no of valid photos
    func getPhotosCount() -> Int {
        var counter = 0
        for photo in photosForUploadUpdate {
            if photo.image != nil {
                counter += 1
            }
        }
        return counter
    }
    
    /// Regenerate IDs for current photos
    func populateIdsForUploadUpdatePhotos() {
        for index in 0..<photosForUploadUpdate.count {
            if photosForUploadUpdate[index].image != nil {
                photosForUploadUpdate[index].id = String(index)
            }
        }
    }
    
    /// Regenerate IDs for all photos (valid and empty)
    func populateIdsForAllPhotos() {
        for index in 0..<photosForUploadUpdate.count {
            photosForUploadUpdate[index].id = String(index)
        }
    }
    
    /// Populate rest of the current frames with empty photos
    func populateWithEmptyPhotos() {
        if self.photosForUploadUpdate.count<6 {
            for _ in 0..<(6-photosForUploadUpdate.count) {
                self.photosForUploadUpdate.append(Photo())
            }
        }
    }
    
    /// Download photos from firebase and populate the current photo arrays
    func populatePhotos() {
        self.downloadedPhotos.removeAll()
        self.downloadedPhotosURLs.sort { $0.id! < $1.id! }
        for (index, url) in self.downloadedPhotosURLs.enumerated() {
            SDWebImageManager.shared.loadImage(with: url.imageURL, options: .continueInBackground, progress: nil) { [weak self] (image, data, error, cacheType, finished, durl) in
                guard let sself = self else { return }

                if let err = error {
                    print(err)
                    return
                }

                guard let image = image else {
                    // No image handle this error
                    return
                }
                let isDuplicate = sself.downloadedPhotos.contains(where: { photo in
                    if photo.id == String(index) {
                        return true
                    }
                    else {
                        return false
                    }
                })
                if !isDuplicate {
                    sself.downloadedPhotos.append(Photo(id: String(index), image: image, downsampledImage: image.downsample(to: CGSize(width: 115, height: 170)), firebaseImagePath: url.firebaseImagePath))
                    print("Downloaded photos \(index+1)/\(sself.downloadedPhotosURLs.count)")
                    if sself.downloadedPhotos.count == Array(Set(sself.downloadedPhotosURLs)).count {
                        sself.downloadedPhotos.sort { $0.id! < $1.id! }
                        sself.photosForUploadUpdate = sself.downloadedPhotos
                        sself.populateWithEmptyPhotos()
                        sself.populateIdsForAllPhotos()
                    }
                }
            }

        }
        print("Count = \(Set(self.downloadedPhotos).count)")
    }
    
    /// To check if Minimum 2 photos for the user exists
    func checkMinUserPhotosAdded() {
        if photosFetchedAndReady {
            if downloadedPhotosURLs.count >= 2 {
                self.minUserPhotosAdded = true
            }
            else {
                self.minUserPhotosAdded = false
            }
        }
    }
    
    /// Download photo URLs for photos saved in firebase and populatePhotos()
    func getPhotos() {
        var urls = [DownloadedPhotoURL]()
        let storageRef = storage.reference()
        let path = "images/\(Auth.auth().currentUser?.uid ?? "tempUser")"
        let storageReference = storageRef.child(path)
        storageReference.listAll { (result, error) in
            if result.items.count == 0 {
                self.photosFetchedAndReady = true
                self.downloadedPhotosURLs.removeAll()
                self.downloadedPhotos.removeAll()
                self.photosForUploadUpdate = [Photo](repeating: Photo(), count: 6)
                self.checkMinUserPhotosAdded()
            }
            if let error = error {
                print("ERROR IN STORAGE REFERENCE: \(error.localizedDescription)")
            }
            for item in result.items {
                // List items under images/<User UID> folder
                var itemCount = result.items.count
                print("Result from Item Listing: \(item)")
                // Download in memory with a maximum allowed size of 5MB (5 * 1024 * 1024 bytes)
                item.downloadURL{url, error in
                    if let error = error {
                        print("Couldn't Download \(item.fullPath.split(separator: "/").last!)")
                        print(error)
                        itemCount -= 1
                    } else {
                        let imageName = String(item.fullPath.split(separator: "/").last!)
                        print("Download URL for \(String(describing: imageName)): \(String(describing: url!))")
                        urls.append(DownloadedPhotoURL(id: imageName, imageURL: url!, firebaseImagePath: item.fullPath))
                        if itemCount == urls.count {
                            self.downloadedPhotosURLs = urls
                            self.populatePhotos()
                            self.photosFetchedAndReady = true
                            self.checkMinUserPhotosAdded()
                        }
                    }
                }
            }
        }
    }
    
    /// Common code to be used for uploading a photo to firebase storage
    func firebaseStorageUpload(photo: Photo, filename: String, isUpdateProcess: Bool, onFinish: @escaping () -> Void) {
        do {
            guard let imageData = try photo.image?.heicData(compressionQuality: 0.6) else { return }
            
            let storageRef = storage.reference()
            let imagePath = "images/\(Auth.auth().currentUser?.uid ?? "tempUser")/\(filename)"
            let imageRef = storageRef.child(imagePath)
            // Create the file metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/heic"
            
            // Upload file and metadata to the object 'images/<User UID>/<filename>.heic'
            let uploadTask = imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                print("Size for \(filename) is \(size)")
                // You can also access to download URL after upload.
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    print("Download URL for \(filename) is \(downloadURL)")
                    self.uploadCompletionCode(isUpdateProcess: isUpdateProcess, downloadURL: downloadURL, filename: filename, newImagePath: imagePath)
                }
            }
            
            // Listen for state changes, errors, and completion of the upload.
            uploadTask.observe(.resume) { snapshot in
                // Upload resumed, also fires when the upload starts
            }
            
            uploadTask.observe(.pause) { snapshot in
                // Upload paused
            }
            
            uploadTask.observe(.progress) { snapshot in
                // Upload reported progress
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            }
            
            uploadTask.observe(.success) { snapshot in
                print("Upload completed successfully")
                onFinish()
            }
            
            uploadTask.observe(.failure) { snapshot in
                if let error = snapshot.error as NSError? {
                    switch (StorageErrorCode(rawValue: error.code)!) {
                    case .objectNotFound:
                        print("File doesn't exist")
                        break
                    case .unauthorized:
                        print("User doesn't have permission to access file")
                        break
                    case .cancelled:
                        print("User canceled the upload")
                        break
                    case .unknown:
                        print("Unknown error occurred, inspect the server response")
                        break
                    default:
                        print("A separate error occurred. This is a good place to retry the upload.")
                        break
                    }
                }
            }
            
            
        }
        catch {
            print(error)
        }
    }
    
    /// Code to be used after upload/update of photo is complete
    func uploadCompletionCode(isUpdateProcess: Bool, downloadURL: URL, filename: String, newImagePath: String) {
        if isUpdateProcess {
            if let replaceIndex = self.downloadedPhotosURLs.firstIndex(where: { oldURL in
                if oldURL.firebaseImagePath == newImagePath {
                    return true
                }
                else {
                    return false
                }
            }) {
                self.downloadedPhotosURLs[replaceIndex].imageURL = downloadURL
            }
            else {
                self.downloadedPhotosURLs.append(DownloadedPhotoURL(id: filename, imageURL: downloadURL, firebaseImagePath: newImagePath))
            }
            if self.downloadedPhotosURLs.count == self.getPhotosCount() {
                self.populatePhotos()
            }
        }
        else {
            self.downloadedPhotosURLs.append(DownloadedPhotoURL(id: filename, imageURL: downloadURL, firebaseImagePath: newImagePath))
            if self.downloadedPhotosURLs.count>=2 {
                self.photosFetchedAndReady = true
                self.checkMinUserPhotosAdded()
            }
            if self.downloadedPhotosURLs.count >= self.getPhotosCount() {
                self.populatePhotos()
            }
        }
    }
    
    /// Used for adding photos the first time user uploads photos
    func uploadPhotos() {
        self.downloadedPhotosURLs.removeAll()
        for (index, photo) in self.photosForUploadUpdate.enumerated() {
            if photo.image != nil {
                let filename = "image\(index+1).heic"
                self.firebaseStorageUpload(photo: photo, filename: filename, isUpdateProcess: false) {
                    return
                }
            }
        }
    }
    
    /// Upload new/Update Old photo from Profile page
    func uploadUpdateSinglePhoto(photo: Photo, filename: String?, isUpdate: Bool, onFinish: @escaping () -> Void) {
        if photo.image != nil {
            if filename == nil {
                if let filename = photo.firebaseImagePath?.split(separator: "/").last {
                    self.firebaseStorageUpload(photo: photo, filename: String(filename), isUpdateProcess: isUpdate, onFinish: onFinish)
                }
            }
            else {
                self.firebaseStorageUpload(photo: photo, filename: String(filename!), isUpdateProcess: isUpdate, onFinish: onFinish)
            }
        }
    }
    
    /// Used for re-uploading images placed after the deleted image, with rectified names and firebase storage paths
    func uploadUpdateMultiplePhotos(photos: ArraySlice<Photo>) {
        self.downloadedPhotosURLs.removeAll()
        for (index, photo) in zip(photos.indices, photos) {
            if photo.image != nil {
                let filename = "image\(index+1).heic"
                self.firebaseStorageUpload(photo: photo, filename: filename, isUpdateProcess: false) {
                    return
                }
            }
        }
    }
    
    /// Clear all images from SD Web Image Cache -- Generally on Delete/Update
    func clearAllImageCache() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: nil)
    }
    
    /// To delete the given photo from Firebase Storage
    func deleteMissingPhoto(missing: Photo, onFinish: @escaping () -> Void) {
        let storageRef = storage.reference()
        let deleteRef = storageRef.child(missing.firebaseImagePath!)
        
        // Delete the file
        deleteRef.delete { error in
            if let error = error {
                print("Couldn't delete \(String(describing: missing.firebaseImagePath?.split(separator: "/").last))")
                print(error)
                onFinish()
            } else {
                print("Photo \(String(describing: missing.firebaseImagePath?.split(separator: "/").last)) was deleted.")
                onFinish()
            }
        }
    }
    
}
