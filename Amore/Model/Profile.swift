//
//  ProfileModel.swift
//  Amore
//
//  Created by Piyush Garg on 30/09/21.
//

import Foundation


struct Profile: Identifiable, Codable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var dateOfBirth: Date
    var interests: [String]
    var genderIdentity: String
    var sexualOrientation: [String]
    var sexualOrientationVisible: Bool
    var showMePreference: String
    var work: String?
    var school: String?
}
