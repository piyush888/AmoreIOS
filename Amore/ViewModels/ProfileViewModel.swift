//
//  ProfileViewModel.swift
//  Amore
//
//  Created by Piyush Garg on 01/10/21.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData
import CoreLocation

class ProfileViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @AppStorage("log_Status") var logStatus = false
    var userProfile = Profile()
    @Published var editUserProfile = Profile()
    @Published var storeManagerObj = StoreManager() // Object
    @Published var storeProfileV2 = ProfileViewModelV2()
    
    let db = Firestore.firestore()
    var profileCores = [ProfileCore]()
    
    @Published var phoneNumber = String()
    @Published var verificationCode = String()
    @Published var currentVerificationId = String()
    @Published var countryCode = String()
    
    // Alert...
    @Published var showAlert = false
    @Published var errorMsg = ""
    
    // Variables for alert
    @Published var profileFetchedAndReady = false
    @Published var profileCreationDone = false
    @Published var loginFormVisible = false
    @Published var minPhotosAdded: Bool = false
    
    // Variables for Location
    @Published var authorizationStatus: CLAuthorizationStatus
    var lastSeenLocation: CLLocation?
    var lastSeenLocationGeohash: Geohash?
    private let locationManager: CLLocationManager
    
    // Store Profile in Backend
    
    @Published var requestInProcessing: Bool = false
    // time out after continious error from backend
    @Published var timeOutRetriesCount: Int = 0
    @Published var adminAuthModel = AdminAuthenticationViewModel()
    var apiURL = "http://127.0.0.1:5040"
    
    let viewContext = PersistenceController.shared.container.viewContext
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // Call this to give a location pop-up
    func getLocationOnce() {
        locationManager.requestLocation()
//        print("Location: Location Requested")
    }
    
    // Mark - Location Manager Delegate Methods
    // This method will be started when the auhtorization of location manager changes
    // If user "Denies" it will never be called again, until
    // - User deletes the application or go in settings to change location
    // This will be called everytime a user chooses "Give Access Ones" & application is
    // Opened next time
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = locationManager.authorizationStatus
        // Handle each case of location permissions
        if [CLAuthorizationStatus.authorizedWhenInUse, CLAuthorizationStatus.authorizedAlways].contains(authorizationStatus) {
            locationManager.startUpdatingLocation()
//            locationManager.requestLocation()
        }
        else {
            locationManager.stopUpdatingLocation()
        }
//        print("Location: authorizationStatus Updated")
    }
    
    // Get updated user location - Depend on authorization
    func requestPermission() {
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Tells the delegate when new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else {return}
        lastSeenLocation = userLocation
        self.getGeohash(apiToBeUsed: "/getgeohash", precision: 12) {} onSuccess: {
            if let geohash = self.lastSeenLocationGeohash?.geohash {
                self.editUserProfile.geohash = geohash
                self.editUserProfile.geohash2 = String(geohash[..<geohash.index(geohash.startIndex, offsetBy: 2)])
                self.editUserProfile.geohash3 = String(geohash[..<geohash.index(geohash.startIndex, offsetBy: 3)])
                self.editUserProfile.geohash4 = String(geohash[..<geohash.index(geohash.startIndex, offsetBy: 4)])
                self.editUserProfile.geohash5 = String(geohash[..<geohash.index(geohash.startIndex, offsetBy: 5)])
            }
//            print("Location: Geohash Updated: ", self.editUserProfile.geohash as Any)
        }
//        editUserProfile.location = Location(longitude: userLocation.coordinate.longitude, latitude: userLocation.coordinate.latitude)
//        print("Location: Location Updated")
//        editUserProfile.location?.longitude = userLocation.coordinate.longitude
//        editUserProfile.location?.latitude = userLocation.coordinate.latitude
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
//        print("Location: Failed to acquire user location.")
    }
    
    //// API Call to get Geohash for the User Location
    func getGeohash(apiToBeUsed:String, precision: Int, onFailure: @escaping () -> Void, onSuccess: @escaping () -> Void)  -> Void {
        var geohash = Geohash()
        requestInProcessing = true
        guard let url = URL(string: self.apiURL + apiToBeUsed) else { onFailure()
                return
        }
        let body: [String: Any] = ["latitude": lastSeenLocation?.coordinate.latitude as Any, "longitude": lastSeenLocation?.coordinate.longitude as Any, "precision": precision]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error in API: \(error)")
                onFailure()
                return
            }
            
            if let data = data {
                // Check if you receive a valid httpresponse
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            do {
                                geohash = try JSONDecoder().decode(Geohash.self, from: data)
                                self.lastSeenLocationGeohash = geohash
                            }
                            catch let jsonError as NSError {
                                print("ProfileViewModel")
                              print("JSON decode failed: \(jsonError.localizedDescription)")
                            }
                            self.requestInProcessing = false
                            self.timeOutRetriesCount = 0
                            // send back the temp data
                            onSuccess()
                        }
                    }
                    else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                        print("Unable to fetch getohash")
                        DispatchQueue.main.async {
                            if self.timeOutRetriesCount < 1 {
                                self.timeOutRetriesCount += 1
                                self.adminAuthModel.serverLogin()
                                self.getGeohash(apiToBeUsed: apiToBeUsed, precision: precision, onFailure: onFailure, onSuccess:onSuccess)
                            }
                            self.requestInProcessing = false
                        }
                    }
                }
            }
        }.resume()
    }
    
    func calculateUserAge() {
        let now = Date()
        let birthday: Date = self.userProfile.dateOfBirth ?? Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        self.userProfile.age = ageComponents.year!
    }
    
    func fetchProfileCoreData () {
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
        calculateUserAge()
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
    
//    func signIn(streamObj: StreamViewModel, adminAuthenticationObj:AdminAuthenticationViewModel) {
    func signIn(adminAuthenticationObj:AdminAuthenticationViewModel) {

        if let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") {
            print(verificationID+" in sign in!")
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)

            Auth.auth().signIn(with: credential) { (authResult, error) in
                DispatchQueue.main.async { [self] in
                    if let error = error {
                        self.showAlert = true
                        print(error.localizedDescription)
                        return
                    }
                    else {
                        if let authRes = authResult {
                            UserDefaults.standard.set(authRes.user.uid, forKey: "userUID")
                            if self.profileFetchedAndReady {
                                self.profileFetchedAndReady = false
                            }
                            self.getUserProfile()
//                            streamObj.streamLogin(uid: authRes.user.uid)
                            adminAuthenticationObj.serverLogin()
                        }
                        self.loginFormVisible = false
                    }
                }
            }
        }
    }
    
    func createUserProfile() -> Bool {
        do {
            let profileCore = ProfileCore(context: viewContext)
            self.updateProfileCore(profileCore: profileCore)
            try viewContext.save()
        }
        catch {
            print("Core Data Storing failed during profile creation...:\(error)")
        }
        // Firestore Write
        let collectionRef = db.collection("Profiles")
        if let id = userProfile.id {
            do {
                self.userProfile.wasProfileUpdated = true
                let newDocReference = try collectionRef.document(id).setData(from: userProfile)
                print("Profile stored in firestore with new document reference: \(newDocReference)")
                self.editUserProfile = self.userProfile
                // Set profileFetchedAndReady = True, right after profile creation.
                self.profileFetchedAndReady = true
                
                // New Profile Create Document for user in IAPPurchase
                // Default Consumable & Free Subscription
                // Current Free Consumables Limit 20th March 22
                _ = self.storeManagerObj.storePurchaseWithParams(product:ConsumableCountAndSubscriptionModel(
                                                purchasedBoostCount:0,
                                                purchasedSuperLikesCount:0,
                                                purchasedMessagesCount:0,
                                                totalBoostCount: 1,
                                                totalSuperLikesCount: 2,
                                                totalMessagesCount: 1,
                                                subscriptionTypeId: "Amore.ProductId.12M.Free.v1"))
                
                // Updating profile in backend too
                _ = storeProfileV2.writeUserProfileToBackend(userProfile:self.userProfile)
                
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
    
    
    func checkLogin() {
        logStatus = Auth.auth().currentUser == nil ? false : true
        print("Logged In: "+String(logStatus))
    }
    
    
    func getUserProfile() {
        // Example function, Firestore Read Implementation
        let collectionRef = db.collection("Profiles")
        if let documentId = Auth.auth().currentUser?.uid {
            let docRef = collectionRef.document(documentId)
            // Get Data from Firestore. Network Action -- Async Behaviour at this point
            docRef.getDocument { [self] document, error in
                if let error = error as NSError? {
                    print("Error getting document: \(error.localizedDescription)")
                }
                else {
                    if let document = document {
                        do {
                            // 1 - Get User Profile from Firestore.
                            self.userProfile = try document.data(as: Profile.self) ?? Profile()
                            self.editUserProfile = self.userProfile

                            // 2 - Storing Profile Data to Core
                            self.fetchProfileCoreData()
                            do {
                                var profileCore: ProfileCore?
                                // If Core Data already exists, update Core Data
                                if (self.profileCores.count>0) {
                                    profileCore = self.profileCores[0]
                                }
                                // Create new Core Data Record -- When profile data available in Firestore but not yet stored in Core Data
                                // Example: User Registered -> Profile Exists in Firestore -> Uninstalled -> Installed -> Signed In
                                else {
                                    profileCore = ProfileCore(context: viewContext)
                                }
                                self.updateProfileCore(profileCore: profileCore!)
                                // Save Profile data in Core Data Store only if Profile not empty
                                if profileCore?.email != nil {
                                    try viewContext.save()
                                }
                                self.profileFetchedAndReady = true
                                print("Profile Refresh done...")
                            }
                            catch {
                                print("Core Data Storing failed during profile fetch...:\(error)")
                            }
                            
                            // 3 - Updating profile in backend too
                            _ = storeProfileV2.writeUserProfileToBackend(userProfile:self.userProfile)
                            
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
    
    func updateUserProfile(profileId: String?) {
        if let profileId = profileId {
            editUserProfile.location = Location(longitude: lastSeenLocation?.coordinate.longitude, latitude: lastSeenLocation?.coordinate.latitude)
            editUserProfile.geohash = lastSeenLocationGeohash?.geohash
            if let geohash = self.lastSeenLocationGeohash?.geohash {
                self.editUserProfile.geohash = geohash
                self.editUserProfile.geohash2 = String(geohash[..<geohash.index(geohash.startIndex, offsetBy: 2)])
                self.editUserProfile.geohash3 = String(geohash[..<geohash.index(geohash.startIndex, offsetBy: 3)])
                self.editUserProfile.geohash4 = String(geohash[..<geohash.index(geohash.startIndex, offsetBy: 4)])
                self.editUserProfile.geohash5 = String(geohash[..<geohash.index(geohash.startIndex, offsetBy: 5)])
            }
//            print("Location: Current Location \(String(describing: editUserProfile.location))")
//            print("Location: Current Location Geohash \(String(describing: editUserProfile.geohash))")
            if editUserProfile != userProfile {
                do {
                    print("Update Profile Information on Firestore...")
                    self.calculateProfileCompletion()
                    self.editUserProfile.wasProfileUpdated = true
                    try db.collection("Profiles").document(profileId).setData(from: editUserProfile)
                    self.userProfile = self.editUserProfile
                    // also updating cache and backend
                    _ = storeProfileV2.writeUserProfileToBackend(userProfile:self.userProfile)
                }
                catch {
                    print("Error while updating Profile in Firestore: ")
                    print(error.localizedDescription)
                }
            }
            else {
                print("No change in Profile Info...")
            }
        }
    }
    
    func numOfUserPhotosAdded() -> Int {
        var counter = 0
        if userProfile.image1?.imageURL != nil { counter += 1 }
        if userProfile.image2?.imageURL != nil { counter += 1 }
        if userProfile.image3?.imageURL != nil { counter += 1 }
        if userProfile.image4?.imageURL != nil { counter += 1 }
        if userProfile.image5?.imageURL != nil { counter += 1 }
        if userProfile.image6?.imageURL != nil { counter += 1 }
        return counter
    }
    
    func checkMinNumOfPhotosUploaded() {
        minPhotosAdded = numOfUserPhotosAdded() >= 2 ? true : false
    }
    
    func defragmentProfileImagesArray() {
        /// **Defragment photos array#
        /// -- ## profileImages = [im1, im2....im6]
        /// -- ## remove non image elems
        /// -- ## append non image elems
        /// -- ## rewrite ids
        /// -- ## assign back to im1, im2, im3,...im6
        var profileImages = [editUserProfile.image1, editUserProfile.image2, editUserProfile.image3, editUserProfile.image4, editUserProfile.image5, editUserProfile.image6]
        profileImages = profileImages.filter({ profileImage in
            return (profileImage?.imageURL != nil)
        })
        for _ in 0..<6-profileImages.count {
            profileImages.append(ProfileImage())
        }
        
        editUserProfile.image1 = profileImages[0]
        editUserProfile.image2 = profileImages[1]
        editUserProfile.image3 = profileImages[2]
        editUserProfile.image4 = profileImages[3]
        editUserProfile.image5 = profileImages[4]
        editUserProfile.image6 = profileImages[5]
    }
    
    func calculateProfileCompletion() {
        let mirror = Mirror(reflecting: userProfile)
        var noOfProperties = 0.0
        var score = 0.0
        for child in mirror.children {
            if child.label != "profileCompletion" {
                if case Optional<Any>.none = child.value {
                } else {
                    if child.label!.contains("image") {
                        if (child.value as! ProfileImage).imageURL != nil {
                            score += 1
                        }
                    }
                    else {
                        score += 1
                    }
                }
                noOfProperties += 1
            }
        }
        let completionPercentage = (score/noOfProperties)*100
        print("Profile Completion Percentage: ", completionPercentage)
        if editUserProfile.id == nil {
            //// If the profile is being created for the first time.
            userProfile.profileCompletion = Double(round(100 * completionPercentage) / 100)
        }
        else {
            editUserProfile.profileCompletion = Double(round(100 * completionPercentage) / 100)
        }
    }
}

