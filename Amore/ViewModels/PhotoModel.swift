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
    
    func getPhotosCount() -> Int {
        var counter = 0
        for photo in photosForUploadUpdate {
            if photo.image != nil {
                counter += 1
            }
        }
        print("Total number of photos: \(counter)")
        return counter
    }
    
    func populatePhotos() {
        self.downloadedPhotos.removeAll()
        self.downloadedPhotosURLs.sort { $0.id! < $1.id! }
        for (index, url) in self.downloadedPhotosURLs.enumerated() {
            SDWebImageDownloader.shared.downloadImage(with: url.imageURL, completed: {image,_,_,_ in
                let isDuplicate = self.downloadedPhotos.contains(where: { photo in
                    if photo.id == String(index) {
                        return true
                    }
                    else {
                        return false
                    }
                })
                if !isDuplicate {
                    self.downloadedPhotos.append(Photo(id: String(index), image: image, downsampledImage: image?.downsample(to: CGSize(width: 115, height: 170))))
                    print("Downloaded photos \(index+1)/\(self.downloadedPhotosURLs.count)")
                    if self.downloadedPhotos.count == Array(Set(self.downloadedPhotosURLs)).count {
                        self.downloadedPhotos.sort { $0.id! < $1.id! }
                        self.photosForUploadUpdate = self.downloadedPhotos
                    }
                }
            })
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
        let storageReference = storageRef.child("images/\(Auth.auth().currentUser?.uid ?? "tempUser")")
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
                print("Result from Item Listing: \(item)")
                // Download in memory with a maximum allowed size of 5MB (5 * 1024 * 1024 bytes)
                item.downloadURL{url, error in
                    if let error = error {
                        print(error)
                    } else {
                        print("Download URL for \(String(describing: item.fullPath.split(separator: "/").last)): \(String(describing: url!))")
                        urls.append(DownloadedPhotoURL(id: String(item.fullPath.split(separator: "/").last!), imageURL: url!))
                        if result.items.count == urls.count {
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
    
    func uploadPhotos() {
        self.downloadedPhotosURLs.removeAll()
        for (index, photo) in self.photosForUploadUpdate.enumerated() {
            if photo.image != nil {
                do {
                    guard let imageData = try photo.image?.heicData(compressionQuality: 0.6) else { return }

                    let storageRef = storage.reference()
                    let filename = "image\(index+1).heic"
                    
                    let imageRef = storageRef.child("images/\(Auth.auth().currentUser?.uid ?? "tempUser")/\(filename)")
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
                            self.downloadedPhotosURLs.append(DownloadedPhotoURL(id: filename, imageURL: downloadURL))
                            if self.downloadedPhotosURLs.count>=2 {
                                self.photosFetchedAndReady = true
                                self.checkMinUserPhotosAdded()
                            }
                            if self.downloadedPhotosURLs.count >= self.getPhotosCount() {
                                self.populatePhotos()
                            }
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
        }
    }

}
