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
    private let locationManager: CLLocationManager
    
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
        print("Location: Current Location \(filterAndLocationData.location)")
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
}
