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

    let storage = Storage.storage()
    @Published var deleteTriggered = false
    @Published var photo1 = Photo()
    @Published var photo2 = Photo()
    @Published var photo3 = Photo()
    @Published var photo4 = Photo()
    @Published var photo5 = Photo()
    @Published var photo6 = Photo()
    
    /// **___________________________________________________________________________________________________________________________**
    
    /// UploadPhotoWindow will directly be populated by download url and SDWebImage
    /// UploadPhotoWindow will be supplied single variables and not elements of photoForUploadUpdate array
    
    /// Common code to be used for uploading a photo to firebase storage
    func firebaseStorageUpload(photo: Photo, filename: String, isUpdateProcess: Bool, onFinish: @escaping () -> Void, onURLAvailable: @escaping (_ url: URL, _ imagePath: String) -> Void) {
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
                    onURLAvailable(downloadURL, imagePath)
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
    
    func uploadSinglePhoto(photo: inout Photo, onURLAvailable: @escaping (_ url: URL, _ imagePath: String) -> Void, onFinish: @escaping () -> Void) {
        /// **Upload single photo#
        /// ## Will accept image object
        /// -- upload photo
        /// -- ## store firebase image path
        /// -- ## store download url
        /// -- Defragment array (If a blank window is left)
        /// -- organise images from array into Profile model
        /// -- Update firestore Profile document immediately
        firebaseStorageUpload(photo: photo, filename: "image\(NSDate().timeIntervalSince1970).heic", isUpdateProcess: false, onFinish: onFinish, onURLAvailable: onURLAvailable)
    }
    
    func deleteSinglePhoto(profileImage: ProfileImage, onFinish: @escaping () -> Void, onSuccess: @escaping () -> Void) {
        /// **Delete single photo#
        if profileImage.firebaseImagePath == nil {
            return
        }
        let storageRef = storage.reference()
        let deleteRef = storageRef.child(profileImage.firebaseImagePath!)
        
        // Delete the file
        deleteRef.delete { error in
            if let error = error {
                print("Couldn't delete \(String(describing: profileImage.firebaseImagePath?.split(separator: "/").last))")
                print(error)
                onFinish()
            } else {
                print("Photo \(String(describing: profileImage.firebaseImagePath?.split(separator: "/").last)) was deleted.")
                onSuccess()
                onFinish()
            }
        }
    }
    
    func deletePhotoByPath(path: String) {
        let storageRef = storage.reference()
        let deleteRef = storageRef.child(path)
        
        // Delete the file
        deleteRef.delete { error in
            if let error = error {
                print("Couldn't delete \(path)")
                print(error)
            } else {
                print("Photo \(path) was deleted.")
            }
        }
    }
    
    /// Clear all images from SD Web Image Cache -- Generally on Delete/Update
    func clearAllImageCache() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: nil)
    }
    
    /// **___________________________________________________________________________________________________________________________**


    
}
