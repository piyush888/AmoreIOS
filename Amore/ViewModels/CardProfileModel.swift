//
//  CardProfileModel.swift
//  Amore
//
//  Created by Piyush Garg on 24/11/21.
//

import Foundation
import SDWebImageSwiftUI
import UIKit

class CardProfileModel: ObservableObject {
    
    // Cards Data
    @Published var allCards = [CardProfile]()
    @Published var allCardsWithPhotosDeck1 = [CardProfileWithPhotos]()
    @Published var allCardsWithPhotosDeck2 = [CardProfileWithPhotos]()
    
    @Published var deck1Zndex: Double = 1.0
    @Published var deck2Zndex: Double = 0.0
    
    
    @Published var cardsDictionary: [String: CardProfileWithPhotos] = [:]
    
    // Number of Profiles to be fetched per pull
    @Published var userAdjustedFetchProfiles: Int = 10
    
    public var imageWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var imageHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var apiURL = "http://127.0.0.1:5000"
    
    
    // Call this function to fetch profiles from the backend server
    func fetchProfile(numberOfProfiles:Int) {
        print("FETCH PROFILE TRIGGERED........")
        // fetchprofiles is the api where you can profiles
        guard let url = URL(string: self.apiURL + "/fetchprofiles") else { return }
        // add the pay load to the request
        let body: [String: Int] = ["numberOfProfiles": numberOfProfiles]
        
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
                    DispatchQueue.main.async {
                        do {
                            self.allCards =  try JSONDecoder().decode([CardProfile].self, from: data)
                        }
                        catch let jsonError as NSError {
                          print("JSON decode failed: \(jsonError.localizedDescription)")
                        }
                        self.updateCardProfilesWithPhotos()
                        return
                    }
                }
            }
            return
        }.resume()
        
    }
    
    func updateCardProfilesWithPhotos() {
        var tempCardsWithPhotos = [CardProfileWithPhotos]()
        for card in allCards {
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
                                                         workType: card.workType,
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
                                                         doYouWantBabies: card.doYouWantBabies)
            tempCardsWithPhotos.append(cardProfileWithPhoto)
            cardsDictionary[card.id!] = cardProfileWithPhoto
        }
        
        if allCardsWithPhotosDeck1.count == 0 {
            allCardsWithPhotosDeck1 = tempCardsWithPhotos
            self.deck1Zndex = 0
            self.deck2Zndex = 1
        } else if allCardsWithPhotosDeck2.count == 0 {
            allCardsWithPhotosDeck2 = tempCardsWithPhotos
            self.deck1Zndex = 1
            self.deck2Zndex = 0
        }
        
    }
    
    
    
    func areMoreCardsNeeded() {
        if (allCardsWithPhotosDeck1.count == 0) || (allCardsWithPhotosDeck2.count == 0) {
            // Yes more cards are needed
            self.fetchProfile(numberOfProfiles: self.userAdjustedFetchProfiles)
        } else {
            print("Both deck have data")
        }
    }
    
}
