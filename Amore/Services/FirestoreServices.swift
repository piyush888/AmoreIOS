//
//  ProfileServices.swift
//  Amore
//
//  Created by Piyush Garg on 01/10/21.
//

import Foundation
import Firebase

class FirestoreServices {
    public static let db = Firestore.firestore()
    
    public static var requestInProcessing: Bool = false
    // time out after continious error from backend
    public static var adminAuthModel = AdminAuthenticationViewModel()
    public static var apiURL = "http://127.0.0.1:5040"
    
    public static func storeLikesDislikes(apiToBeUsed:String, onFailure: @escaping () -> Void, onSuccess: @escaping () -> Void, swipedUserId: String?, swipeInfo: AllCardsView.LikeDislike) {
        var subCollection: String? {
            switch swipeInfo{
            case .like: return "Likes"
            case .dislike: return "Dislikes"
            case .superlike: return "Superlikes"
            case .none: return nil
            }
        }
        
        if let swipedUserId = swipedUserId {
            if let subCollection = subCollection {
                requestInProcessing = true
                guard let url = URL(string: self.apiURL + apiToBeUsed) else { onFailure()
                        return
                    }
                let body: [String: String] = ["currentUserID": Auth.auth().currentUser!.uid, "swipeInfo": subCollection, "swipedUserID": swipedUserId]
                let finalBody = try! JSONSerialization.data(withJSONObject: body)
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = finalBody
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    if let error = error {
                        print("Error in API \(apiToBeUsed): \(error)")
                        onFailure()
                        return
                    }
                    
                    if let _ = data {
                        // Check if you receive a valid httpresponse
                        if let httpResponse = response as? HTTPURLResponse {
                            
                            if httpResponse.statusCode == 200 {
                                DispatchQueue.main.async {
                                    print("Stored Successfully")
                                    onSuccess()
                                    self.requestInProcessing = false
                                    return
                                }
                            }
                            else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                                DispatchQueue.main.async {
                                    print("Unable to store LikeDislike Firestore: \(apiToBeUsed), swipedUserId:\(swipedUserId)")
                                    onFailure()
                                    self.requestInProcessing = false
                                }
                            }
                        }
                    }
                }.resume()
            }
        }
    }
    
    public static func upgradeLikeToSuperlike(apiToBeUsed:String, onFailure: @escaping () -> Void, onSuccess: @escaping () -> Void, swipedUserId: String?, swipeInfo: AllCardsView.LikeDislike) {
        var subCollection: String? {
            switch swipeInfo{
            case .like: return "Likes"
            case .dislike: return "Dislikes"
            case .superlike: return "Superlikes"
            case .none: return nil
            }
        }
        
        if let swipedUserId = swipedUserId {
            if let subCollection = subCollection {
                requestInProcessing = true
                guard let url = URL(string: self.apiURL + apiToBeUsed) else { onFailure()
                        return
                    }
                let body: [String: String] = ["currentUserID": Auth.auth().currentUser!.uid, "swipeInfo": subCollection, "swipedUserID": swipedUserId]
                let finalBody = try! JSONSerialization.data(withJSONObject: body)
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = finalBody
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    if let error = error {
                        print("Error in API \(apiToBeUsed): \(error)")
                        onFailure()
                        return
                    }
                    
                    if let _ = data {
                        // Check if you receive a valid httpresponse
                        if let httpResponse = response as? HTTPURLResponse {
                            
                            if httpResponse.statusCode == 200 {
                                DispatchQueue.main.async {
                                    print("Upgraded Like to Superlike Successfully")
                                    onSuccess()
                                    self.requestInProcessing = false
                                }
                            }
                            else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                                DispatchQueue.main.async {
                                    onFailure()
                                    self.requestInProcessing = false
                                    print("Unable to upgrade LikeDislike Firestore: \(apiToBeUsed), upgradeLikeToSuperlike:\(swipedUserId)")
                                }
                            }
                        }
                    }
                }.resume()
            }
        }
    }
    
    public static func undoLikeDislikeFirestore(apiToBeUsed:String, onFailure: @escaping () -> Void, onSuccess: @escaping (_ tempData: CardProfile) -> Void) {
        var rewindedUserCard = CardProfile(CardProfileWithPhotos())
        requestInProcessing = true
        guard let url = URL(string: self.apiURL + apiToBeUsed) else { onFailure()
                return
            }
        let body: [String: String] = ["currentUserID": Auth.auth().currentUser!.uid]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error in API \(apiToBeUsed): \(error)")
                onFailure()
                return
            }
            
            if let data = data {
                // Check if you receive a valid httpresponse
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            do {
                                rewindedUserCard = try JSONDecoder().decode(CardProfile.self, from: data)
                                onSuccess(rewindedUserCard)
                                print("Rewind Operation Successful")
                            }
                            catch let jsonError as NSError {
                              print("JSON decode failed Rewind Swipe: \(jsonError.localizedDescription)")
                                onFailure()
                            }
                            self.requestInProcessing = false
                            return
                        }
                    }
                    else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                        print("Unable to undo LikeDislike Firestore: \(apiToBeUsed), currentUserId:\(Auth.auth().currentUser?.uid)")
                        DispatchQueue.main.async {
                            onFailure()
                            self.requestInProcessing = false
                        }
                    }
                }
            }
        }.resume()
    }
    
    public static func unmatchUser(apiToBeUsed:String, onFailure: @escaping () -> Void, onSuccess: @escaping () -> Void, otherUserId: String?) {
        if let otherUserId = otherUserId {
            requestInProcessing = true
            guard let url = URL(string: self.apiURL + apiToBeUsed) else { onFailure()
                    return
                }
            let body: [String: String] = ["current_user_id": Auth.auth().currentUser!.uid, "other_user_id": otherUserId]
            let finalBody = try! JSONSerialization.data(withJSONObject: body)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = finalBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error in API \(apiToBeUsed): \(error)")
                    onFailure()
                    return
                }
                
                if let _ = data {
                    // Check if you receive a valid httpresponse
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            DispatchQueue.main.async {
                                onSuccess()
                                self.requestInProcessing = false
                                print("Unmatch Operation Successful")
                            }
                        }
                        else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                            DispatchQueue.main.async {
                                onFailure()
                                self.requestInProcessing = false
                                print("Error: Unable to ")
                            }
                        }
                    }
                }
            }.resume()
        
        }
        
    }
    
    /**
     API Call to match two users on approval of Direct Message request.

     - Parameter:
        - apiToBeUsed: API Endpoint
        - onFailure: Code block to be executed on failure of API call
        - onSuccess: Code block to be executed on success of API call
        - otherUserId: User ID of the other user in Chat

     - Returns: API Status as Boolean.
     */
    public static func directMessageMatchUsers(apiToBeUsed:String, onFailure: @escaping () -> Void, onSuccess: @escaping () -> Void, otherUserId: String?) {
        if let otherUserId = otherUserId {
            requestInProcessing = true
            guard let url = URL(string: self.apiURL + apiToBeUsed) else { onFailure()
                    return
                }
            let body: [String: String] = ["currentUserId": Auth.auth().currentUser!.uid, "otherUserId": otherUserId]
            let finalBody = try! JSONSerialization.data(withJSONObject: body)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = finalBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error in API \(apiToBeUsed): \(error)")
                    onFailure()
                    return
                }
                
                if let _ = data {
                    // Check if you receive a valid httpresponse
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            DispatchQueue.main.async {
                                onSuccess()
                                self.requestInProcessing = false
                                print("Direct Message Matching Successful")
                            }
                        }
                        else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                            DispatchQueue.main.async {
                                onFailure()
                                self.requestInProcessing = false
                                print("Error: Unable to Match Profiles for Direct Message")
                            }
                        }
                    }
                }
            }.resume()
        
        }
    }
    
}
