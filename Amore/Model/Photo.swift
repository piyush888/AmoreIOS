//
//  Photo.swift
//  Amore
//
//  Created by Piyush Garg on 20/10/21.
//

import Foundation
import SwiftUI

struct DownloadedPhotoURL: Identifiable, Codable, Hashable {
    public var id: String?
    var imageURL: URL?
}

struct DownloadedPhoto: Identifiable, Hashable {
    public var id: String?
    var image: UIImage?
}

//struct PhotoForUploadUpdate: Identifiable, Hashable {
//    public var id: String?
//    var image: UIImage?
//    var downsampledImage: UIImage?
//}
