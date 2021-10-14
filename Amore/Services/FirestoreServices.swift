//
//  ProfileServices.swift
//  Amore
//
//  Created by Piyush Garg on 01/10/21.
//

import Foundation
import Firebase

class FirestoreServices {
    public static let storage = Storage.storage()
    
    public static func uploadImage(imageData: Data, filename: String) {
        let storageRef = storage.reference()
        
        let imageRef = storageRef.child("images/\(Auth.auth().currentUser?.uid ?? "tempUser")/\(filename).heic")
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/heic"
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            print("Size for \(filename) is \(size)")
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            print("Download URL for \(filename) is \(downloadURL)")
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
            // Upload completed successfully
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    print("File doesn't exist")
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    print("User doesn't have permission to access file")
                    break
                case .cancelled:
                    // User canceled the upload
                    print("User canceled the upload")
                    break
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    print("Unknown error occurred, inspect the server response")
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
}
