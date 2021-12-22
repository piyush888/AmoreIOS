//
//  FilterAndLocationModel.swift
//  Amore
//
//  Created by Piyush Garg on 22/11/21.
//

import Foundation
import Firebase
import CoreLocation

class FilterAndLocationModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var filterAndLocationData = FiltersAndLocation()
    var oldFilterAndLocationData = FiltersAndLocation()
    let db = Firestore.firestore()
    @Published var filterAndLocationDataFetched = false
    
    @Published var authorizationStatus: CLAuthorizationStatus
    var lastSeenLocation: CLLocation?
    var lastSeenLocationGeohash: Geohash?
    private let locationManager: CLLocationManager
    
    @Published var requestInProcessing: Bool = false
    // time out after continious error from backend
    @Published var timeOutRetriesCount: Int = 0
    @Published var adminAuthModel = AdminAuthenticationViewModel()
    var apiURL = "http://127.0.0.1:5000"
    
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
        print("Location: Location Requested")
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
        print("Location: authorizationStatus Updated")
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
            self.filterAndLocationData.geohash = self.lastSeenLocationGeohash
            print("Location: Geohash Updated: ", self.filterAndLocationData.geohash)
        }
//        filterAndLocationData.location = Location(longitude: userLocation.coordinate.longitude, latitude: userLocation.coordinate.latitude)
        print("Location: Location Updated")
//        filterAndLocationData.location?.longitude = userLocation.coordinate.longitude
//        filterAndLocationData.location?.latitude = userLocation.coordinate.latitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
        print("Location: Failed to acquire user location.")
    }
    
    func createFilterAndLocation() -> Bool {
        // Firestore Write
        let collectionRef = db.collection("FilterAndLocation")
        if let id = oldFilterAndLocationData.id {
            do {
                let newDocReference = try collectionRef.document(id).setData(from: oldFilterAndLocationData)
                print("filterAndLocationData stored in firestore with new document reference: \(newDocReference)")
                self.filterAndLocationData = self.oldFilterAndLocationData
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
    
    func getFilterAndLocation() {
        // Example function, Firestore Read Implementation
        self.filterAndLocationDataFetched = false
        let collectionRef = db.collection("FilterAndLocation")
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
                            // Get User Profile from Firestore.
                            self.oldFilterAndLocationData = try document.data(as: FiltersAndLocation.self) ?? FiltersAndLocation()
                            self.filterAndLocationData = self.oldFilterAndLocationData
                            print("Location: Filter and Location data Refresh done...")
                            self.filterAndLocationDataFetched = true
                        }
                        catch {
                            print(error)
                            self.filterAndLocationDataFetched = true
                        }
                    }
                }
//                self.filterAndLocationDataFetched = true
            }
        }
        
    }
    
    func updateFilterAndLocation() {
        filterAndLocationData.location = Location(longitude: lastSeenLocation?.coordinate.longitude, latitude: lastSeenLocation?.coordinate.latitude)
        filterAndLocationData.geohash = Geohash(geohash: lastSeenLocationGeohash?.geohash)
        print("Location: Current Location \(filterAndLocationData.location)")
        print("Location: Current Location Geohash \(filterAndLocationData.geohash)")
        if let profileId = Auth.auth().currentUser?.uid {
            if filterAndLocationData != oldFilterAndLocationData {
                do {
                    print("Location: Updating FilterAndLocationData on Firestore...")
                    try db.collection("FilterAndLocation").document(profileId).setData(from: filterAndLocationData)
                    print(filterAndLocationData)
                    oldFilterAndLocationData = filterAndLocationData
                }
                catch {
                    print("Location: Error while updating FilterAndLocationData in Firestore: ")
                    print(error.localizedDescription)
                }
            }
            else {
                print("Location: No change in FilterAndLocation Data...")
            }
        }
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
                              print("JSON decode failed: \(jsonError.localizedDescription)")
                            }
                            self.requestInProcessing = false
                            if self.timeOutRetriesCount > 0 {
                                self.timeOutRetriesCount = 0
                            }
                            // send back the temp data
                            onSuccess()
                        }
                    }
                    else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                        DispatchQueue.main.async {
                            if self.timeOutRetriesCount < 10 {
                                self.timeOutRetriesCount += 1
                                self.adminAuthModel.serverLogin()
                                self.getGeohash(apiToBeUsed: apiToBeUsed,precision: precision, onFailure: onFailure, onSuccess:onSuccess)
                            }
                            self.requestInProcessing = false
                        }
                    }
                }
            }
        }.resume()
    }
}
