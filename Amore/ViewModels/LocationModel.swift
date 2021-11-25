////
////  LocationModel.swift
////  Amore
////
////  Created by Kshitiz Sharma on 9/30/21.
////
//
//import Foundation
//import CoreLocation
//
//class LocationModel: NSObject, CLLocationManagerDelegate , ObservableObject {
//    
//    /*
//        // Documentation to read for knowledge and understan functionality
//        // https://developer.apple.com/documentation/corelocation/cllocationmanager/1620562-requestwheninuseauthorization
//        // https://developer.apple.com/documentation/corelocation/cllocationmanager/1620551-requestalwaysauthorization
//    */
//    // This property will be used in other view to check the location authorization status
//    @Published var authorizationStatus: CLAuthorizationStatus
//    @Published var lastSeenLocation: CLLocation?
//    private let locationManager: CLLocationManager
// 
//    // Over-rides init of the NSObject
//    override init() {
//        locationManager = CLLocationManager()
//        authorizationStatus = locationManager.authorizationStatus
//        
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//    }
//    
//    // Call this to give a location pop-up
//    func getLocationOnce() {
//        locationManager.requestLocation()
//    }
//    
//    // Mark - Location Manager Delegate Methods
//    // This method will be started when the auhtorization of location manager changes
//    // If user "Denies" it will never be called again, until
//    // - User deletes the application or go in settings to change location
//    // This will be called everytime a user chooses "Give Access Ones" & application is
//    // Opened next time
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationStatus = locationManager.authorizationStatus
//        // Handle each case of location permissions
//        if [CLAuthorizationStatus.authorizedWhenInUse, CLAuthorizationStatus.authorizedAlways].contains(authorizationStatus) {
//            locationManager.startUpdatingLocation()
//        }
//        else {
//            locationManager.stopUpdatingLocation()
//        }
//    }
//    
//    // Get updated user location - Depend on authorization
//    func requestPermission() {
//        if authorizationStatus == .notDetermined {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//    
//    // Tells the delegate when new location data is available
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let userLocation = locations.last else {return}
//        lastSeenLocation = userLocation
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        // Handle failure to get a user’s location
//        print("Failed to acquire user location.")
//    }
//    
//    // This will only be called when new user location data is available
//    func getProfiles(location:CLLocation) {
//        
//        print(String(location.coordinate.latitude))
//        print(String(location.coordinate.longitude))
//        // TODO - Piyush
//        // Store the location and time of location in the firestore
//        
//        // We need to create an api to fetch the latest profile
//        
//    }
//    
//    
//}
