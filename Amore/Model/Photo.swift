//
//  Photo.swift
//  Amore
//
//  Created by Piyush Garg on 20/10/21.
//

import Foundation
import SwiftUI

struct DownloadedPhoto: Identifiable, Codable {
    public var id: String?
    var imageURL: URL?
}
