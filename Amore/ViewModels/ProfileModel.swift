//
//  ProfileViewModel.swift
//  Amore
//
//  Created by Piyush Garg on 01/10/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class ProfileViewModel: ObservableObject {
    var userProfile = Profile()
    let db = Firestore.firestore()
    var profileCores = [ProfileCore]()
    @Published var profileFetchedAndReady = false
    
    func fetchProfileCoreData (viewContext: NSManagedObjectContext) {
        let request = ProfileCore.profileFetchRequest()
        request.sortDescriptors = []
        if let id = Auth.auth().currentUser?.uid {
            request.predicate = NSPredicate(format: "id contains %@", id)
        }
        do {
            let results = try viewContext.fetch(request)
            self.profileCores = results
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func updateProfileCore (profileCore: ProfileCore) {
        if self.userProfile.id == nil {
            self.userProfile.id = Auth.auth().currentUser?.uid
        }
        
        profileCore.id = userProfile.id
        profileCore.firstName = userProfile.firstName
        profileCore.lastName = userProfile.lastName
        profileCore.email = userProfile.email
        profileCore.dateOfBirth = userProfile.dateOfBirth
        profileCore.interests = userProfile.interests
        profileCore.genderIdentity = userProfile.genderIdentity
        profileCore.sexualOrientation = userProfile.sexualOrientation
        profileCore.sexualOrientationVisible = userProfile.sexualOrientationVisible ?? true
        profileCore.showMePreference = userProfile.showMePreference
        profileCore.work = userProfile.work
        profileCore.school = userProfile.school
    }
    
    func createUserProfile(context: NSManagedObjectContext) -> Bool {
        do {
            let profileCore = ProfileCore(context: context)
            self.updateProfileCore(profileCore: profileCore)
            try context.save()
        }
        catch {
            print("Core Data Storing failed during profile creation...:\(error)")
        }
        // Firestore Write
        let collectionRef = db.collection("Profiles")
        if let id = userProfile.id {
            do {
                let newDocReference = try collectionRef.document(id).setData(from: userProfile)
                print("Profile stored in firestore with new document reference: \(newDocReference)")
                // Set profileFetchedAndReady = True, right after profile creation.
                self.profileFetchedAndReady = true
                return true
            }
            catch let error {
                print("Error writing document to Firestore: \(error)")
            }
        }
        else{
            print("No user uid")
        }
        return false
    }
    
    func getUserProfile(context: NSManagedObjectContext) {
        // Example function, Firestore Read Implementation
        let collectionRef = db.collection("Profiles")
        if let documentId = Auth.auth().currentUser?.uid {
            let docRef = collectionRef.document(documentId)
            // Get Data from Firestore. Network Action -- Async Behaviour at this point
            docRef.getDocument { document, error in
                if let error = error as NSError? {
                    print("Error getting document: \(error.localizedDescription)")
                }
                else {
                    if let document = document {
                        do {
                            // Get User Profile from Firestore.
                            self.userProfile = try document.data(as: Profile.self) ?? Profile()

                            self.fetchProfileCoreData(viewContext: context)
                            do {
                                var profileCore: ProfileCore?
                                // If Core Data already exists, update Core Data
                                if (self.profileCores.count>0) {
                                    profileCore = self.profileCores[0]
                                }
                                // Create new Core Data Record -- When profile data available in Firestore but not yet stored in Core Data
                                // Example: User Registered -> Profile Exists in Firestore -> Uninstalled -> Installed -> Signed In
                                else {
                                    profileCore = ProfileCore(context: context)
                                }
                                self.updateProfileCore(profileCore: profileCore!)
                                // Save Profile data in Core Data Store only if Profile not empty
                                if profileCore?.email != nil {
                                    try context.save()
                                }
                                self.profileFetchedAndReady = true
                                print("Profile Refresh done...")
                            }
                            catch {
                                print("Core Data Storing failed during profile fetch...:\(error)")
                            }
                        }
                        catch {
                            print(error)
                        }
                    }
                }
                self.profileFetchedAndReady = true
            }
        }
    }
}
