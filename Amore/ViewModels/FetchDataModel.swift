//
//  FetchDataModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/12/21.
//

import Foundation

class FetchDataModel {
    
    @Published var requestInProcessing: Bool = false
    @Published var timeOutRetriesCount: Int = 0
    @Published var adminAuthModel = AdminAuthenticationViewModel()
    var apiURL = "http://127.0.0.1:5040"

    func fetchData(apiToBeUsed:String, requestBody:[String: String], onFailure: @escaping () -> Void, onSuccess: @escaping (_ tempData: [CardProfile]) -> Void)  -> Void {
        var tempData = [CardProfile]()
        requestInProcessing = true
        guard let url = URL(string: self.apiURL + apiToBeUsed) else { onFailure()
                return
        }
        let finalBody = try! JSONSerialization.data(withJSONObject: requestBody)
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
                                tempData =  try JSONDecoder().decode([CardProfile].self, from: data)
                            }
                            catch let jsonError as NSError {
                              print("JSON decode failed: \(jsonError.localizedDescription)")
                            }
                            self.requestInProcessing = false
                            if self.timeOutRetriesCount > 0 {
                                self.timeOutRetriesCount = 0
                            }
                            // send back the temp data
                            onSuccess(tempData)
                        }
                    }
                    else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                        DispatchQueue.main.async {
                            // number of retries 3
                            if self.timeOutRetriesCount < 1 {
                                self.timeOutRetriesCount += 1
                                self.adminAuthModel.serverLogin()
                                self.fetchData(apiToBeUsed: apiToBeUsed,requestBody:["DataStatus": "No Data"],onFailure: onFailure,onSuccess:onSuccess)
                            }
                            self.requestInProcessing = false
                        }
                    }
                }
            }
        }.resume()
    }
    
    func updateCardProfilesWithPhotos(tempData:[CardProfile]) -> (cardsWithPhotos: [CardProfileWithPhotos],
                                                                  cardsDict: [String: CardProfileWithPhotos])  {
        var tempCardsWithPhotos = [CardProfileWithPhotos]()
        var temp_Dict: [String: CardProfileWithPhotos] = [:]
        for card in tempData {
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
                                                         doYouWantBabies: card.doYouWantBabies)
            tempCardsWithPhotos.append(cardProfileWithPhoto)
            temp_Dict[card.id!] = cardProfileWithPhoto
        }
        return (tempCardsWithPhotos,temp_Dict)
    }
    
}
    
