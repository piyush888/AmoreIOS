//
//  CardProfileModel.swift
//  Amore
//
//  Created by Piyush Garg on 24/11/21.
//

import Foundation
import CoreLocation
import CoreGraphics

class CardProfileModel: ObservableObject {
    
    // Cards Data
    @Published var allCards = [CardProfile]()
    @Published var allCardsWithPhotosDeck = [CardProfileWithPhotos]()
    @Published var cardsDictionary: [String: CardProfileWithPhotos] = [:]
    // Number of Profiles to be fetched per pull
    @Published var userAdjustedFetchProfiles: Int = 10
    // time out after continious error from backend
    @Published var timeOutRetriesCount: Int = 0
    @Published var profilesBeingFetched: Bool = false
    
    @Published var adminAuthModel = AdminAuthenticationViewModel()
    @Published var lastSwipedCard: CardProfileWithPhotos? = nil
    @Published var lastSwipeInfo: AllCardsView.LikeDislike? = nil
    @Published var filterRadius: CGFloat? = 2
    
    var apiURL = "http://127.0.0.1:5000"
    
    
    // Call this function to fetch profiles from the backend server
    func fetchProfile(numberOfProfiles:Int) {
        profilesBeingFetched = true
        // fetchprofiles is the api where you can profiles
        guard let url = URL(string: self.apiURL + "/fetchprofiles") else { return }
        // add the pay load to the request
        let body: [String: Any] = ["numberOfProfiles": numberOfProfiles,
                                   "idsAlreadyInDeck":allCardsWithPhotosDeck.map({ (card:CardProfileWithPhotos)-> String in card.id! })]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                // nil responses - Service is down, since the response is nil
                self.timeOutRetriesCount = self.timeOutRetriesCount + 5
                print("Error in API: \(error)")
                return
            }
            
            if let data = data {
                // Check if you receive a valid httpresponse
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            do {
                                self.allCards =  try JSONDecoder().decode([CardProfile].self, from: data)
                            }
                            catch let jsonError as NSError {
                                print("CardProfileModel")
                              print("JSON decode failed: \(jsonError.localizedDescription)")
                            }
                            self.updateCardProfilesWithPhotos()
                            self.profilesBeingFetched = false
                            if self.timeOutRetriesCount > 0 {
                                self.timeOutRetriesCount = 0
                            }
                            return
                        }
                    }
                    else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                        DispatchQueue.main.async {
                            if self.timeOutRetriesCount < 3 {
                                self.timeOutRetriesCount += 1
                                self.adminAuthModel.serverLogin()
                                self.fetchProfile(numberOfProfiles:10)
                            }
                            self.profilesBeingFetched = false
                        }
                    }
                }
            }
            return
        }.resume()
        
    }
    
    // Call this function to fetch profiles from the backend server
    func fetchProfilesWithinRadius(numberOfProfiles:Int, latitude: Double, longitude: Double) {
        profilesBeingFetched = true
        // fetchprofiles is the api where you can profiles
        guard let url = URL(string: self.apiURL + "/fetchprofileswithinradius") else { return }
        // add the pay load to the request
        let body: [String: Any] = ["numberOfProfiles": numberOfProfiles,
                                   "idsAlreadyInDeck":allCardsWithPhotosDeck.map({ (card:CardProfileWithPhotos)-> String in card.id! }),
                                   "latitude": latitude,
                                   "longitude": longitude,
                                   "radius": filterRadius as Any]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error in API: \(error)")
            }
            
            if let data = data {
                // Check if you receive a valid httpresponse
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            do {
                                self.allCards =  try JSONDecoder().decode([CardProfile].self, from: data)
                            }
                            catch let jsonError as NSError {
                                print("CardProfileModel")
                              print("JSON decode failed: \(jsonError.localizedDescription)")
                            }
                            self.updateCardProfilesWithPhotos()
                            self.profilesBeingFetched = false
                            if self.timeOutRetriesCount > 0 {
                                self.timeOutRetriesCount = 0
                            }
                            return
                        }
                    }
                    else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                        DispatchQueue.main.async {
                            // number of retries 3
                            if self.timeOutRetriesCount < 3 {
                                self.timeOutRetriesCount += 1
                                self.adminAuthModel.serverLogin()
                                self.fetchProfilesWithinRadius(numberOfProfiles: 10, latitude: latitude, longitude: longitude)
                            }
                            self.profilesBeingFetched = false
                        }
                    }
                }
            }
            return
        }.resume()
        
    }
    
    func updateCardProfilesWithPhotos() {
        var tempCardsWithPhotos = [CardProfileWithPhotos]()
        
        for card in allCards {
            
            if let location = card.location {
                let profileLocation = CLLocation(latitude: location.latitude.boundDouble,
                                            longitude: location.longitude.boundDouble)
                
            }
            
            let cardProfileWithPhoto = CardProfileWithPhotos(id: card.id,
                                                         firstName: card.firstName,
                                                         lastName: card.lastName,
                                                         dateOfBirth: card.dateOfBirth,
                                                         interests: card.interests,
                                                         sexualOrientation: card.sexualOrientation,
                                                         sexualOrientationVisible: card.sexualOrientationVisible,
                                                         showMePreference: card.showMePreference,
                                                         work: card.work,
                                                         school: card.school,
                                                         age: card.age,
                                                         headline: card.headline,
                                                         profileDistanceFromUser: card.profileDistanceFromUser,
                                                         jobTitle: card.jobTitle,
                                                         careerField: card.careerField,
                                                         height: card.height,
                                                         education: card.education,
                                                         religion: card.religion,
                                                         community: card.community,
                                                         politics: card.politics,
                                                         location: card.location,
                                                         description: card.description,
                                                         country: card.country,
                                                         image1: card.image1,
                                                         image2: card.image2,
                                                         image3: card.image3,
                                                         image4: card.image4,
                                                         image5: card.image5,
                                                         image6: card.image6,
                                                         doYouWorkOut: card.doYouWorkOut,
                                                         doYouDrink: card.doYouDrink,
                                                         doYouSmoke: card.doYouSmoke,
                                                         doYouWantBabies: card.doYouWantBabies,
                                                         profileCompletion:card.profileCompletion)
            tempCardsWithPhotos.append(cardProfileWithPhoto)
            cardsDictionary[card.id!] = cardProfileWithPhoto
        }
        allCardsWithPhotosDeck = tempCardsWithPhotos + allCardsWithPhotosDeck
        self.areMoreCardsNeeded()
    }
    
    func areMoreCardsNeeded() {	
        
        if allCardsWithPhotosDeck.count < 34 && self.profilesBeingFetched == false {
            // Yes more cards are needed
            self.fetchProfile(numberOfProfiles: 50)
//            print("Count: Cards Being fetched ", allCardsWithPhotosDeck.count)
        } else {
            print("Both deck have data")
        }
    }
    
    func removeCard() {
      allCardsWithPhotosDeck.removeLast()
    }
    
}
