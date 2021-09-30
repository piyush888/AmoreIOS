//
//  ProfileModel.swift
//  Amore
//
//  Created by Piyush Garg on 30/09/21.
//

import Foundation


class Profile: Identifiable, Decodable {
    
    var firstName: String
    var lastName: String
    var email: String
    var dateOfBirth: Date
    var interests: [String]
    var genderIdentity: String
    var sexualOrientation: [String]
    var sexualPreference: [String]
    var work: String?
    var education: String?
}
