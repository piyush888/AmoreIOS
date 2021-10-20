//
//  PhotoModel.swift
//  Amore
//
//  Created by Piyush Garg on 20/10/21.
//

import Foundation
import Firebase
import UIKit

class PhotoModel: ObservableObject {
    
    @Published var downloadedPhotosURLs = [DownloadedPhoto]()
    
    func getPhotos() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let storageReference = storageRef.child("images/\(Auth.auth().currentUser?.uid ?? "tempUser")")
        storageReference.listAll { (result, error) in
            if let error = error {
                print(error.localizedDescription)
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
                        self.downloadedPhotosURLs.append(DownloadedPhoto(id: String(item.fullPath.split(separator: "/").last!), imageURL: url!))
                    }
                }
            }
        }
    }
    
    func uploadPhotos(photos: [UIImage?]) {
        for (index, image) in photos.enumerated() {
            if image != nil {
                do {
                    guard let imageData = try image?.heicData(compressionQuality: CGFloat(0.6)) else { return }
                    FirestoreServices.uploadImage(imageData: imageData, filename: "image\(index+1)")
                }
                catch {
                    print(error)
                }
            }
        }
    }

}
