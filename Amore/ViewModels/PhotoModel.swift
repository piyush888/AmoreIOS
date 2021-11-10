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
    
    func defragmentArray() {
        var newArray = photosForUploadUpdate
        var toBeDeleted: [Photo] = []
        for photo in newArray {
            if photo.image == nil && photo.firebaseImagePath != nil {
                toBeDeleted.append(photo)
            }
        }
        newArray.removeAll { photo in
            if photo.image == nil {
                return true
            }
            else {
                return false
            }
        }
        newArray.append(contentsOf: toBeDeleted)
        for _ in 0..<(6-newArray.count) {
            newArray.append(Photo())
        }
        photosForUploadUpdate = newArray
    }
    
    func getPhotosCount() -> Int {
        var counter = 0
        for photo in photosForUploadUpdate {
            if photo.image != nil {
                counter += 1
            }
        }
        return counter
    }
    
    func populateIdsForUploadUpdatePhotos() {
        for index in 0..<photosForUploadUpdate.count {
            if photosForUploadUpdate[index].image != nil {
                photosForUploadUpdate[index].id = String(index)
            }
        }
    }
    
    func populateWithEmptyPhotos() {
        if self.photosForUploadUpdate.count<6 {
            for _ in 0..<(6-photosForUploadUpdate.count) {
                self.photosForUploadUpdate.append(Photo())
            }
        }
    }
    
    func populatePhotos() {
        self.downloadedPhotos.removeAll()
        self.downloadedPhotosURLs.sort { $0.id! < $1.id! }
        for (index, url) in self.downloadedPhotosURLs.enumerated() {
            SDWebImageManager.shared.loadImage(with: url.imageURL, options: .continueInBackground, progress: nil) { [weak self] (image, data, error, cacheType, finished, durl) in
                guard let sself = self else { return }

                if let err = error {
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
                    }
                }
            }
            
//            SDWebImageDownloader.shared.downloadImage(with: url.imageURL, completed: {image,_,_,_ in
//                let isDuplicate = self.downloadedPhotos.contains(where: { photo in
//                    if photo.id == String(index) {
//                        return true
//                    }
//                    else {
//                        return false
//                    }
//                })
//                if !isDuplicate {
//                    self.downloadedPhotos.append(Photo(id: String(index), image: image, downsampledImage: image?.downsample(to: CGSize(width: 115, height: 170)), firebaseImagePath: url.firebaseImagePath))
//                    print("Downloaded photos \(index+1)/\(self.downloadedPhotosURLs.count)")
//                    if self.downloadedPhotos.count == Array(Set(self.downloadedPhotosURLs)).count {
//                        self.downloadedPhotos.sort { $0.id! < $1.id! }
//                        self.photosForUploadUpdate = self.downloadedPhotos
//                        self.populateWithEmptyPhotos()
//                    }
//                }
//            })
        }
        print("Count = \(Set(self.downloadedPhotos).count)")
    }
    
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
    
    func firebaseStorageUpload(photo: Photo, filename: String, isUpdateProcess: Bool) {
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
    
    func uploadPhotos() {
        self.downloadedPhotosURLs.removeAll()
        for (index, photo) in self.photosForUploadUpdate.enumerated() {
            if photo.image != nil {
                let filename = "image\(index+1).heic"
                self.firebaseStorageUpload(photo: photo, filename: filename, isUpdateProcess: false)
            }
        }
    }
    
    func rectifyFirebaseImagePaths() {
        for index in 0..<photosForUploadUpdate.count {
            if photosForUploadUpdate[index].firebaseImagePath != nil {
                photosForUploadUpdate[index].firebaseImagePath = "images/\(Auth.auth().currentUser?.uid ?? "tempUser")/image\(index+1).heic"
            }
        }
    }
    
    func removeUpdatedDeletedImagesFromCache(photo: Photo) {
        if let index = (photo.firebaseImagePath?.split(separator: "/").last?.split(separator: ".").first?.last?.wholeNumberValue) {
            let url = downloadedPhotosURLs[index-1].imageURL?.absoluteString
            SDImageCache.shared.removeImage(forKey: url) {
                print("Removed URL: \(String(describing: url))")
                print("Removed \(String(describing: photo.firebaseImagePath?.split(separator: "/").last)) from CACHE")
            }
        }
    }
    
    func compareAllPhotosForChanges() -> [Int] {
        var shouldClearImageCache = false
        var changedPhotosIndexes = [Int]()
        rectifyFirebaseImagePaths()
        for (index, (photo1, photo2)) in (zip(downloadedPhotos, photosForUploadUpdate)).enumerated() {
            if !(photo1.image?.isEqualPhoto(compareTo: photo2.image ?? UIImage()))! {
                // removeUpdatedDeletedImagesFromCache(photo: photo1)
                shouldClearImageCache = true
                if photo2.image == nil && photo2.firebaseImagePath != nil {
                    /// Trigger Delete
                    print("TRIGGERING DELETE...")
                    deleteMissingPhoto(missing: photo2)
                }
                else {
                    changedPhotosIndexes.append(index)
                }
                self.downloadedPhotosURLs.removeAll { url in
                    if url.firebaseImagePath == photo1.firebaseImagePath { return true }
                    else { return false }
                }
                
            }
        }
        if shouldClearImageCache {
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk(onCompletion: nil)
        }
        return changedPhotosIndexes
    }
    
    func updateChangedPhotos(indexes: [Int]) {
        for index in indexes {
            if photosForUploadUpdate[index].image != nil {
                let filename = "image\(index+1).heic"
                firebaseStorageUpload(photo: photosForUploadUpdate[index], filename: String(filename), isUpdateProcess: true)
            }
        }
    }
    
    func updateNewPhotosAdded() {
        for (index, photo) in zip(photosForUploadUpdate[(downloadedPhotos.count)...].indices, photosForUploadUpdate[(downloadedPhotos.count)...]) {
            if photo.image != nil {
                let filename = "image\(index+1).heic"
                self.firebaseStorageUpload(photo: photo, filename: filename, isUpdateProcess: false)
            }
        }
    }
    
    func deleteMissingPhoto(missing: Photo) {
        let storageRef = storage.reference()
        let deleteRef = storageRef.child(missing.firebaseImagePath!)
        
        // Delete the file
        deleteRef.delete { error in
            if let error = error {
                print("Couldn't delete \(String(describing: missing.firebaseImagePath?.split(separator: "/").last))")
                print(error)
            } else {
                print("Photo \(String(describing: missing.firebaseImagePath?.split(separator: "/").last)) was deleted.")
            }
        }
    }
    
    func updatePhotos() {
        if getPhotosCount() >= 2{
            /// CASES WHERE UPDATE SHALL BE TRIGGERED.
            print("checkpoint 0")
            if downloadedPhotos.count < 6 {
                print("checkpoint 1")
                /// If less than 6 photos exist and a new photo is added -- Difference between size of photosForUploadUpdate and downloadedPhotos
                if downloadedPhotos.count < getPhotosCount() {
                    print("checkpoint 2")
                    /// Get the new photo and upload
                    updateNewPhotosAdded()
                    /// Check if any other photo is different
                    let changedPhotosIndexes = compareAllPhotosForChanges()
                    if changedPhotosIndexes.count>0 {
                        self.updateChangedPhotos(indexes: changedPhotosIndexes)
                    }
                    
                }
                /// If less than 6 photos exist and one of them is changed -- No difference between size of arrays, use isEqualPhoto to compare -- Only changed photos, None added
                else if downloadedPhotos.count == getPhotosCount() {
                    print("checkpoint 3")
                    /// Check if any photo is different
                    let changedPhotosIndexes = compareAllPhotosForChanges()
                    if changedPhotosIndexes.count>0 {
                        self.updateChangedPhotos(indexes: changedPhotosIndexes)
                    }
                }
                /// If less than 6 photos exist and one or more are deleted -- Remove delete button if total count of photos == 2
                else {
                    /// Check if any other photo is different & Delete missing photos
                    print("checkpoint 4")
                    let changedPhotosIndexes = compareAllPhotosForChanges()
                    if changedPhotosIndexes.count>0 {
                        self.updateChangedPhotos(indexes: changedPhotosIndexes)
                    }
                }
                
            }
            
            else if downloadedPhotos.count == 6 {
                /// If all 6 photos exist and one of them is changed -- use isEqualPhoto method to compare images between photosForUploadUpdate and downloadedPhotos
                /// /// If all 6 photos existed and one or more are deleted
                /// Check if any other photo is different & Delete missing photos
                print("checkpoint 4")
                let changedPhotosIndexes = compareAllPhotosForChanges()
                if changedPhotosIndexes.count>0 {
                    self.updateChangedPhotos(indexes: changedPhotosIndexes)
                }
            }
            
            else {
                print("Logical error in photo update module")
            }

        }
        self.getPhotos()
    }
    
}
