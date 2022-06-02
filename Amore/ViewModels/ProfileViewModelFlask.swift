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
    
    /**
     API Call to write profile in Redis using backend.

     - Parameter:
        - userProfile: Profile to be stored

     - Returns: API Status as Boolean.
     */
    func writeUserProfileToBackend(userProfile:Profile) -> Bool {
        self.postingProfileToBackend = true
        guard let url = URL(string: self.apiURL + "/storeProfileInBackend") else { return false}

        let user = User(userProfile)
        do
        {
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "HH:mm E, d MMM y"
            let dateofBirthString = (formatter3.string(from: user.dateOfBirth ?? Date()))
            let jsonData = try JSONEncoder().encode(user)
            var jsonString = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String:AnyObject]
            jsonString?["dateOfBirth"] = dateofBirthString as AnyObject
            let requestBody = ["profile": jsonString]
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
        }
        catch
        {
            print(error)
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
