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
    var age: Int? = 25
    var headline: String?
    var profileDistanceFromUser: Int? = 0
    var jobTitle: String?
    var workType: String?
    var height: Double? = 5.3
    var education: String?
    var religion: String?
    var community: String?
    var politics: String?
    var location: String?
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
}

struct CardProfileWithPhotos: Identifiable, Hashable {
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
    var age: Int? = 25
    var headline: String?
    var profileDistanceFromUser: Int? = 0
    var jobTitle: String?
    var workType: String?
    var height: Double? = 5.3
    var education: String?
    var religion: String?
    var community: String?
    var politics: String?
    var location: String?
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
}
