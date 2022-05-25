//
//  CardProfileModel.swift
//  Amore
//
//  Created by Piyush Garg on 24/11/21.
//

import Foundation
import CoreLocation
import CoreGraphics
import FirebaseAuth

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
    
    var apiURL = "http://127.0.0.1:5040"
    
    func fetchProfile() {
        profilesBeingFetched = true
        guard let url = URL(string: self.apiURL + "/fetchGeoRecommendations") else { return }
        let body: [String: String] = ["profilesCountLeftInDeck": String(allCardsWithPhotosDeck.count)]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error in API \(url): \(error)")
                return
            }
            
            if let data = data {
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            do {
                                self.allCards =  try JSONDecoder().decode([CardProfile].self, from: data)
                            }
                            catch let jsonError as NSError {
                              print("CardProfileModel")
                              print("JSON decode failed CardProfileModel: \(jsonError.localizedDescription)")
                            }
                            self.updateCardProfilesWithPhotos()
                            self.profilesBeingFetched = false
                            self.timeOutRetriesCount = 0
                            return
                        }
                    }
                    else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                        print("Unable to fetch geo profiles.")
                        print("Profiles left in deck \(self.allCardsWithPhotosDeck.count)")
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
    }
    
    func areMoreCardsNeeded() {	
        
        if allCardsWithPhotosDeck.count < 10 && self.profilesBeingFetched == false {
            self.fetchProfile()
        } else {
            print("No data is required in deck")
        }
    }
    
    func removeCard() {
      allCardsWithPhotosDeck.removeLast()
    }
    
}
