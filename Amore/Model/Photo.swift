//
//  Photo.swift
//  Amore
//
//  Created by Piyush Garg on 20/10/21.
//

import Foundation
import SwiftUI

struct DownloadedPhotoURL: Identifiable, Codable {
    public var id: String?
    var imageURL: URL?
}

struct DownloadedPhoto: Identifiable {
    public var id: String?
    var image: UIImage?
}
