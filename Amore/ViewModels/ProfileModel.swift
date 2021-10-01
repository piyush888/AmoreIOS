//
//  ProfileViewModel.swift
//  Amore
//
//  Created by Piyush Garg on 01/10/21.
//

import Foundation

class ProfileViewModel: ObservableObject {
    var userProfile: Profile?
    
    func getUserProfile () {
        
    }
    
    func createUserProfile() -> Bool {
        // Example function, Firestore Write Implementation
        return FirestoreServices.createProfile()
    }
    
    func getUserProfile() -> Profile {
        // Example function, Firestore Read Implementation
        return Profile(id: "testId", firstName: "Test", lastName: "User", email: "test@user.com", dateOfBirth: Date(), interests: ["Photography"], genderIdentity: "Male", sexualOrientation: ["Straight"], sexualOrientationVisible: true, showMePreference: "Women", work: "Freelancer", school: "SRM")
    }
}
