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
    @Published var allCardsWithPhotos = [CardProfileWithPhotos]()
    public var imageWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    // Screen height.
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
        let start = DispatchTime.now()
        var cardsWithPhotos = [CardProfileWithPhotos]()
        for card in allCards {
            var photos = [Photo](repeating: Photo(), count: 6)
            let cardImages = [card.image1, card.image2, card.image3, card.image4, card.image5, card.image6]
            for (index,image) in cardImages.enumerated() {
                if let imageURL = image?.imageURL {
                    getImage(imageURL: imageURL) {
                        return
                    } onSuccess: { image in
                        photos[index] = Photo(image: nil, downsampledImage: image.downsample(to: CGSize(width: self.imageWidth, height: self.imageHeight/1.5)), inProgress: false)
//                        if card.id == self.allCards.last?.id && index+1 < 6 {
//                            guard let _ = cardImages[index+1]?.imageURL else {
//                                print("Clearing Cache of SDWebImage")
//                                SDImageCache.shared.clearMemory()
//                                return
//                            }
//                        }
                    }
                }
            }
            cardsWithPhotos.append(CardProfileWithPhotos(id: card.id,
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
                                                         photo1: photos[0].downsampledImage != nil ? photos[0] : nil,
                                                         image2: card.image2,
                                                         photo2: photos[1].downsampledImage != nil ? photos[1] : nil,
                                                         image3: card.image3,
                                                         photo3: photos[2].downsampledImage != nil ? photos[2] : nil,
                                                         image4: card.image4,
                                                         photo4: photos[3].downsampledImage != nil ? photos[3] : nil,
                                                         image5: card.image5,
                                                         photo5: photos[4].downsampledImage != nil ? photos[4] : nil,
                                                         image6: card.image6,
                                                         photo6: photos[5].downsampledImage != nil ? photos[5] : nil,
                                                         doYouWorkOut: card.doYouWorkOut,
                                                         doYouDrink: card.doYouDrink,
                                                         doYouSmoke: card.doYouSmoke,
                                                         doYouWantBabies: card.doYouWantBabies))
        }
        allCardsWithPhotos = cardsWithPhotos
        print("TIME REQUIRED = \((DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds)/1000000000)")
    }
    
    func getImage(imageURL: URL, onFailure: @escaping () -> Void, onSuccess: @escaping (_ image: UIImage) -> Void) {
        SDWebImageManager.shared.loadImage(with: imageURL, options: [.continueInBackground], progress: nil) { image, data, error, cacheType, finished, durl in
            if let err = error {
                print(err)
                return
            }
            guard let image = image else {
                // No image handle this error
                onFailure()
                return
            }
            onSuccess(image)
        }
    }
    
}
