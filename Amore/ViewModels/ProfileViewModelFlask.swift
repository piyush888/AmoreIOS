//
//  ProfileViewModelFlask.swift
//  Amore
//
//  Created by Kshitiz Sharma on 5/22/22.
//

import Foundation
import FirebaseAuth


class ProfileViewModelV2: ObservableObject {
    
    var apiURL = "http://127.0.0.1:5040"
    var postingProfileToBackend: Bool?
    
    func writeUserProfileToBackend(userProfile:Profile) -> Bool {
        self.postingProfileToBackend = true
        guard let url = URL(string: self.apiURL + "/storeProfileInBackend") else { return false}
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        let dateofBirthString = (formatter3.string(from: userProfile.dateOfBirth ?? Date()))
        
        // Explicity conversting Firestore data object to json object, Firestore otherwise doesn;t allow Firedata conversion to json
        let id = Auth.auth().currentUser?.uid ?? ""
        let firstname = userProfile.firstName ?? ""
        let lastName = userProfile.lastName ?? ""
        let interests:[String] = userProfile.interests ?? [""]
        let genderIdentity = userProfile.genderIdentity ?? ""
        let sexualOrientation:[String] = userProfile.sexualOrientation ?? [""]
        let sexualOrientationVisible = userProfile.sexualOrientationVisible ?? false
        let showMePreference = userProfile.showMePreference ?? ""
        let work = userProfile.work ?? ""
        let school = userProfile.school ?? ""
        let age = userProfile.age ?? 0
        let headline = userProfile.headline ?? ""
        let profileDistanceFromUser = userProfile.profileDistanceFromUser ?? 0.0
        let jobTitle = userProfile.jobTitle ?? ""
        let careerField = userProfile.careerField ?? ""
        let height = userProfile.height ?? 5.5
        let education = userProfile.education ?? ""
        let religion = userProfile.religion ?? ""
        let community = userProfile.community ?? ""
        let politics = userProfile.politics ?? ""
        let latitude = String(userProfile.location?.latitude ?? 0)
        let longitude = String(userProfile.location?.longitude ?? 0)
        let geohash = userProfile.geohash ?? ""
        let geohash2 = userProfile.geohash2 ?? ""
        let geohash3 = userProfile.geohash3 ?? ""
        let geohash4 = userProfile.geohash4 ?? ""
        let geohash5 = userProfile.geohash5 ?? ""
        let description = userProfile.description ?? ""
        let image1URL = userProfile.image1?.imageURL?.absoluteString ?? ""
        let image1ImagePath = userProfile.image1?.firebaseImagePath ?? ""
        let image2URL = userProfile.image1?.imageURL?.absoluteString ?? ""
        let image2ImagePath = userProfile.image1?.firebaseImagePath ?? ""
        let image3URL = userProfile.image1?.imageURL?.absoluteString ?? ""
        let image3ImagePath = userProfile.image1?.firebaseImagePath ?? ""
        let image4URL = userProfile.image1?.imageURL?.absoluteString ?? ""
        let image4ImagePath = userProfile.image1?.firebaseImagePath ?? ""
        let image5URL = userProfile.image1?.imageURL?.absoluteString ?? ""
        let image5ImagePath = userProfile.image1?.firebaseImagePath ?? ""
        let image6URL = userProfile.image1?.imageURL?.absoluteString ?? ""
        let image6ImagePath = userProfile.image1?.firebaseImagePath ?? ""
        let doYouWorkOut = userProfile.doYouWorkOut ?? ""
        let doYouDrink = userProfile.doYouDrink ?? ""
        let doYouSmoke = userProfile.doYouSmoke ?? ""
        let doYouWantBabies = userProfile.doYouWantBabies ?? ""
        let countryRaisedIn = userProfile.countryRaisedIn ?? ""
        let profileCompletion = userProfile.profileCompletion ?? 50.0
        
        // Explicity conversting Firestore data object to json object, Firestore otherwise doesn;t allow Firedata conversion to json
        let requestBody: [String: Any] = ["profile":["id": id,
                                          "firstName": firstname,
                                          "lastName": lastName,
                                          "dateOfBirth": dateofBirthString,
                                          "interests":interests,
                                          "genderIdentity":genderIdentity,
                                          "sexualOrientation":sexualOrientation,
                                          "sexualOrientationVisible":sexualOrientationVisible,
                                          "showMePreference":showMePreference,
                                          "work": work,
                                          "school": school,
                                          "age" : age,
                                          "headline": headline,
                                          "profileDistanceFromUser":profileDistanceFromUser,
                                          "jobTitle": jobTitle,
                                          "careerField": careerField,
                                          "height" : height,
                                          "education": education,
                                          "religion": religion,
                                          "community": community,
                                          "politics": politics,
                                          "location": ["latitude": latitude,
                                                       "longitude": longitude],
                                          "geohash": geohash,
                                          "geohash2": geohash2,
                                          "geohash3": geohash3,
                                          "geohash4": geohash4,
                                          "geohash5": geohash5,
                                          "description": description,
                                          "country": userProfile.country ?? "",
                                          "image1": ["firebaseImagePath":image1ImagePath,
                                                     "imageURL":image1URL],
                                          "image2": ["firebaseImagePath":image2ImagePath,
                                                     "imageURL":image2URL],
                                          "image3": ["firebaseImagePath":image3ImagePath,
                                                     "imageURL":image3URL],
                                          "image4": ["firebaseImagePath":image4ImagePath,
                                                     "imageURL":image4URL],
                                          "image5": ["firebaseImagePath":image5ImagePath,
                                                     "imageURL":image5URL],
                                          "image6": ["firebaseImagePath":image6ImagePath
                                                     ,"imageURL":image6URL],
                                          "doYouWorkOut": doYouWorkOut,
                                          "doYouDrink": doYouDrink,
                                          "doYouSmoke": doYouSmoke,
                                          "doYouWantBabies": doYouWantBabies,
                                          "countryRaisedIn": countryRaisedIn,
                                          "profileCompletion": profileCompletion]]
        let finalBody = try! JSONSerialization.data(withJSONObject: requestBody)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Backend Write
        if let id = userProfile.id {
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error in /postProfileToBackend: \(error)")
                }
                
                if let _ = data {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            print("\(id) Profile was successfully posted to Backend")
                            self.postingProfileToBackend = false
                        }
                        else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                            print("Error writing document to /postProfileToBackend: \(String(describing: error))")
                        }
                    }
                }
            }.resume()
            
            return true
        }
        else{
            print("No user uid")
        }
        return false
    }
    
    
}


//self.fetchDataObj.fetchData(apiToBeUsed: "/commonfetchprofiles",requestBody:["fromCollection": "likesReceived"]) {
//    print("Error while fetching /likesReceived")
//} onSuccess: { tempData in
//    _ = tempData.map{ card in
//        self.prefetchNextCardPhotos(card: card)
//    }
//    let tempResponse = self.fetchDataObj.updateCardProfilesWithPhotos(tempData:tempData)
//    self.superLikesReceivedPhotos = tempResponse.cardsWithPhotos
//    self.superLikesReceivedPhotos_Dict = tempResponse.cardsDict
//}
