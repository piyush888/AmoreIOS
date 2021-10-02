//
//  LocationModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/30/21.
//

import Foundation
import CoreLocation

class LocationModel: NSObject, CLLocationManagerDelegate , ObservableObject {
    
    /*
        // Documentation to read for knowledge and understan functionality
        // https://developer.apple.com/documentation/corelocation/cllocationmanager/1620562-requestwheninuseauthorization
        // https://developer.apple.com/documentation/corelocation/cllocationmanager/1620551-requestalwaysauthorization
    */
 
    var locationManager = CLLocationManager()
    // This property will be used in other view to check the location authorization status
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    
    // Over-rides init of the NSObject
    override init() {
        // Init of the NSObject
        super.init()
        authorizationState = locationManager.authorizationStatus
    }
    
    // Call this to give a location pop-up
    func getLocation() {
        // Set Location Model as the delegate of the location manager
        locationManager.delegate = self
        
        // Request permission from the user
        locationManager.requestWhenInUseAuthorization()
        
        // TODO: Start geolocating the user after permission has been granted
        // locationManager.startUpdatingLocation()
    }
    
    // Mark - Location Manager Delegate Methods
    // This method will be started when the auhtorization of location manager changes
    // If user "Denies" it will never be called again, until
    // - User deletes the application or go in settings to change location
    // This will be called everytime a user chooses "Give Access Ones" & application is
    // Opened next time
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestLocationAgain()
        authorizationState = locationManager.authorizationStatus
    }
    
    // Get updated user location - Depend on authorization
    func requestLocationAgain() {
        if locationManager.authorizationStatus == CLAuthorizationStatus.notDetermined ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
                
            // We have permission
            // Start geolocation the user, after we get permission
            locationManager.startUpdatingLocation()
        }
        else if locationManager.authorizationStatus == .denied {
            // We don't have permission
        }
        authorizationState = locationManager.authorizationStatus
       }
    
    // Tells the delegate when new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.first
        
        if userLocation != nil {
            // Give us the location of the user
            print(locations.first ?? "no location")
            // Stop requesting the location after we get it once
            locationManager.stopUpdatingLocation()
        }
        
        // TODO - Piyush
        // Store the latest location and time of location in the firestore
        // Also get the profiles based on location
        getProfiles( location: userLocation!)
    }
    
    // This will only be called when new user location data is available
    func getProfiles(location:CLLocation) {
        
        print(String(location.coordinate.latitude))
        print(String(location.coordinate.longitude))
        // TODO - Piyush
        // Store the location and time of location in the firestore
        
        // We need to create an api to fetch the latest profile
        
    }
    
    
}
