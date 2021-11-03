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

struct Photo: Identifiable, Hashable, Equatable {
    public var id: String?
    var image: UIImage?
    var downsampledImage: UIImage?
    
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return(lhs.id == rhs.id)
    }
}
