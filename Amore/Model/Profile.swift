//
//  ProfileModel.swift
//  Amore
//
//  Created by Piyush Garg on 30/09/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Profile: Identifiable, Codable, Equatable {
    @DocumentID public var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var dateOfBirth: Date?
    var interests: [String]?
    var genderIdentity: String?
    var sexualOrientation: [String]?
    var sexualOrientationVisible: Bool?
    var showMePreference: String?
    var work: String?
    var school: String?
    var age: Int? = 25
    var headline: String?
    var profileDistanceFromUser: Int? = 0
    var jobTitle: String?
    var workType: String?
    var height: String?
    var education: String?
    var religion: String?
    var community: String?
    var politics: String?
    var location: String?
    var description: String?
    var country: String?
    var discoveryStatus: Bool? = false
    var notificationsStatus: Bool? = false
    
    static func ==(lhs: Profile, rhs: Profile) -> Bool {
        return(lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.email == rhs.email &&
        lhs.dateOfBirth == rhs.dateOfBirth &&
        lhs.interests == rhs.interests &&
        lhs.genderIdentity == rhs.genderIdentity &&
        lhs.sexualOrientation == rhs.sexualOrientation &&
        lhs.sexualOrientationVisible == rhs.sexualOrientationVisible &&
        lhs.showMePreference == rhs.showMePreference &&
        lhs.work == rhs.work &&
        lhs.school == rhs.school &&
        lhs.age == rhs.age &&
        lhs.headline == rhs.headline &&
        lhs.profileDistanceFromUser == rhs.profileDistanceFromUser &&
        lhs.jobTitle == rhs.jobTitle &&
        lhs.workType == rhs.workType &&
        lhs.height == rhs.height &&
        lhs.education == rhs.education &&
        lhs.religion == rhs.religion &&
        lhs.community == rhs.community &&
        lhs.politics == rhs.politics &&
        lhs.location == rhs.location &&
        lhs.description == rhs.description &&
        lhs.country == rhs.country &&
        lhs.discoveryStatus == rhs.discoveryStatus &&
        lhs.notificationsStatus == rhs.notificationsStatus)
    }
}


// Temp User Model being used to display cards
struct User: Hashable, CustomStringConvertible {
    var id: Int
    
    let firstName: String
    let lastName: String
    let age: Int
    let profileDistanceFromUser: Int
    let imageName1: String
    let imageName2: String
    let imageName3: String
    let imageName4: String
    let imageName5: String
    let imageName6: String
    let occupation: String
    let passions: [String]
    let height: String
    let education: String
    let religion: String
    let politics: String
    let location: String
    let description: String
}
