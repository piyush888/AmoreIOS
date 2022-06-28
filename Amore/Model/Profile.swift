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
    var age: Int?
    var headline: String?
    var profileDistanceFromUser: Double?
    var jobTitle: String?
    var careerField: String?
    var height: Double?
    var education: String?
    var religion: String?
    var community: String?
    var politics: String?
    var location: Location?
    var geohash: String?
    var geohash1: String?
    var geohash2: String?
    var geohash3: String?
    var geohash4: String?
    var geohash5: String?
    var description: String?
    var country: String?
    var discoveryStatus: Bool? = false
    var notificationsStatus: Bool? = false
    var image1: ProfileImage? = ProfileImage()
    var image2: ProfileImage? = ProfileImage()
    var image3: ProfileImage? = ProfileImage()
    var image4: ProfileImage? = ProfileImage()
    var image5: ProfileImage? = ProfileImage()
    var image6: ProfileImage? = ProfileImage()
    var doYouWorkOut: String?
    var doYouDrink: String?
    var doYouSmoke: String?
    var doYouWantBabies: String?
    var profileCompletion: Double?
    var countryRaisedIn: String?
    var wasProfileUpdated: Bool?
    var isProfileActive: Bool? = true
    var boostTime: TimeInterval? = 0
    
    
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
               lhs.careerField == rhs.careerField &&
               lhs.height == rhs.height &&
               lhs.education == rhs.education &&
               lhs.religion == rhs.religion &&
               lhs.community == rhs.community &&
               lhs.politics == rhs.politics &&
               lhs.location == rhs.location &&
               lhs.description == rhs.description &&
               lhs.country == rhs.country &&
               lhs.discoveryStatus == rhs.discoveryStatus &&
               lhs.notificationsStatus == rhs.notificationsStatus &&
               lhs.image1 == rhs.image1 &&
               lhs.image2 == rhs.image2 &&
               lhs.image3 == rhs.image3 &&
               lhs.image4 == rhs.image4 &&
               lhs.image5 == rhs.image5 &&
               lhs.image6 == rhs.image6 &&
               lhs.doYouWorkOut == rhs.doYouWorkOut &&
               lhs.doYouDrink == rhs.doYouDrink &&
               lhs.doYouSmoke == rhs.doYouSmoke &&
               lhs.doYouWantBabies == rhs.doYouWantBabies  &&
               lhs.countryRaisedIn == rhs.countryRaisedIn &&
               lhs.location == rhs.location &&
               lhs.geohash == rhs.geohash &&
               lhs.geohash1 == rhs.geohash1 &&
               lhs.geohash2 == rhs.geohash2 &&
               lhs.geohash3 == rhs.geohash3 &&
               lhs.geohash4 == rhs.geohash4 &&
               lhs.geohash5 == rhs.geohash5 &&
               lhs.boostTime == rhs.boostTime
        )
    }
}


/// Model simulating Profile Model above, where `id` attribute
/// is String instead of Firestore Document id.
struct User: Identifiable, Codable, Equatable, Hashable {
    var id: String?
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
    var age: Int?
    var headline: String?
    var profileDistanceFromUser: Double?
    var jobTitle: String?
    var careerField: String?
    var height: Double?
    var education: String?
    var religion: String?
    var community: String?
    var politics: String?
    var location: Location?
    var geohash: String?
    var geohash1: String?
    var geohash2: String?
    var geohash3: String?
    var geohash4: String?
    var geohash5: String?
    var description: String?
    var country: String?
    var discoveryStatus: Bool? = false
    var notificationsStatus: Bool? = false
    var image1: ProfileImage? = ProfileImage()
    var image2: ProfileImage? = ProfileImage()
    var image3: ProfileImage? = ProfileImage()
    var image4: ProfileImage? = ProfileImage()
    var image5: ProfileImage? = ProfileImage()
    var image6: ProfileImage? = ProfileImage()
    var doYouWorkOut: String?
    var doYouDrink: String?
    var doYouSmoke: String?
    var doYouWantBabies: String?
    var profileCompletion: Double?
    var countryRaisedIn: String?
    var wasProfileUpdated: Bool?
    var isProfileActive: Bool? = true
    var boostTime: TimeInterval? = 0
    
    /// Allows initialisation of struct object from Profile Model object
    init(_ profile: Profile) {
        id = profile.id
        firstName = profile.firstName
        lastName = profile.lastName
        email = profile.email
        dateOfBirth = profile.dateOfBirth
        interests = profile.interests
        genderIdentity = profile.genderIdentity
        sexualOrientation = profile.sexualOrientation
        sexualOrientationVisible = profile.sexualOrientationVisible
        showMePreference = profile.showMePreference
        work = profile.work
        school = profile.school
        age = profile.age
        headline = profile.headline
        profileDistanceFromUser = profile.profileDistanceFromUser
        jobTitle = profile.jobTitle
        careerField = profile.careerField
        height = profile.height
        education = profile.education
        religion = profile.religion
        community = profile.community
        politics = profile.politics
        location = profile.location
        geohash = profile.geohash
        geohash1 = profile.geohash1
        geohash2 = profile.geohash2
        geohash3 = profile.geohash3
        geohash4 = profile.geohash4
        geohash5 = profile.geohash5
        description = profile.description
        country = profile.country
        discoveryStatus = profile.discoveryStatus
        notificationsStatus = profile.notificationsStatus
        image1 = profile.image1
        image2 = profile.image2
        image3 = profile.image3
        image4 = profile.image4
        image5 = profile.image5
        image6 = profile.image6
        doYouWorkOut = profile.doYouWorkOut
        doYouDrink = profile.doYouDrink
        doYouSmoke = profile.doYouSmoke
        doYouWantBabies = profile.doYouWantBabies
        profileCompletion = profile.profileCompletion
        countryRaisedIn = profile.countryRaisedIn
        wasProfileUpdated = profile.wasProfileUpdated
        isProfileActive = profile.isProfileActive
        boostTime = profile.boostTime
    }
}

struct Location: Codable, Hashable, Equatable {
    var longitude: Double?
    var latitude: Double?
}

struct Geohash: Codable, Hashable, Equatable {
    var geohash: String?
}
