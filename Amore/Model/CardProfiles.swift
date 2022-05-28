//
//  CardProfiles.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/19/21.
//

import Foundation

struct CardProfile: Identifiable, Codable, Equatable {
    var id: String?
    var firstName: String?
    var lastName: String?
    var dateOfBirth: String?
    var interests: [String]?
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
    var image1: ProfileImage?
    var image2: ProfileImage?
    var image3: ProfileImage?
    var image4: ProfileImage?
    var image5: ProfileImage?
    var image6: ProfileImage?
    var doYouWorkOut: String?
    var doYouDrink: String?
    var doYouSmoke: String?
    var doYouWantBabies: String?
    var countryRaisedIn: String?
    var profileCompletion: Double?
}

struct CardProfileWithPhotos: Identifiable, Hashable, Equatable {
    var id: String?
    var firstName: String?
    var lastName: String?
    var dateOfBirth: String?
    var interests: [String]?
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
    var image1: ProfileImage?
    var photo1: Photo?
    var image2: ProfileImage?
    var photo2: Photo?
    var image3: ProfileImage?
    var photo3: Photo?
    var image4: ProfileImage?
    var photo4: Photo?
    var image5: ProfileImage?
    var photo5: Photo?
    var image6: ProfileImage?
    var photo6: Photo?
    var doYouWorkOut: String?
    var doYouDrink: String?
    var doYouSmoke: String?
    var doYouWantBabies: String?
    var countryRaisedIn: String?
    var profileCompletion: Double?
    
    static func ==(lhs: CardProfileWithPhotos, rhs: CardProfileWithPhotos) -> Bool {
        return(lhs.id == rhs.id &&
               lhs.firstName == rhs.firstName &&
               lhs.lastName == rhs.lastName &&
               lhs.dateOfBirth == rhs.dateOfBirth &&
               lhs.interests == rhs.interests &&
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
               lhs.image1 == rhs.image1 &&
               lhs.image2 == rhs.image2 &&
               lhs.image3 == rhs.image3 &&
               lhs.image4 == rhs.image4 &&
               lhs.image5 == rhs.image5 &&
               lhs.image6 == rhs.image6 &&
               lhs.doYouWorkOut == rhs.doYouWorkOut &&
               lhs.doYouDrink == rhs.doYouDrink &&
               lhs.doYouSmoke == rhs.doYouSmoke &&
               lhs.doYouWantBabies == rhs.doYouWantBabies &&
               lhs.countryRaisedIn == rhs.countryRaisedIn &&
               lhs.location == rhs.location &&
               lhs.geohash == rhs.geohash &&
               lhs.geohash1 == rhs.geohash1 &&
               lhs.geohash2 == rhs.geohash2 &&
               lhs.geohash3 == rhs.geohash3 &&
               lhs.geohash4 == rhs.geohash4 &&
               lhs.geohash5 == rhs.geohash5
        )
    }
}
