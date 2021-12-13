//
//  Photo.swift
//  Amore
//
//  Created by Piyush Garg on 20/10/21.
//

import Foundation
import SwiftUI

//struct DownloadedPhotoURL: Identifiable, Codable, Hashable {
//    public var id: String?
//    var imageURL: URL?
//    var firebaseImagePath: String?
//}

struct Photo: Hashable {
    var image: UIImage?
    var downsampledImage: UIImage?
    var inProgress: Bool? = false
}

struct ProfileImage: Codable, Hashable, Equatable {
    var imageURL: URL?
    var firebaseImagePath: String?
    
    static func ==(lhs: ProfileImage, rhs: ProfileImage) -> Bool {
        return(lhs.imageURL == rhs.imageURL && lhs.firebaseImagePath == rhs.firebaseImagePath)
    }
}
