//
//  ChatUser.swift
//  Amore
//
//  Created by Piyush Garg on 03/02/22.
//

import Foundation

struct ChatUser: Identifiable, Codable, Equatable, Hashable {
    var id: String?
    var firstName: String?
    var lastName: String?
    var image1: ProfileImage?
}
