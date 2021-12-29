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
    public static var timeOutRetriesCount: Int = 0
    public static var adminAuthModel = AdminAuthenticationViewModel()
    public static var apiURL = "http://127.0.0.1:5000"
    
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
                        print("Error in API: \(error)")
                        onFailure()
                        return
                    }
                    
                    if let _ = data {
                        // Check if you receive a valid httpresponse
                        if let httpResponse = response as? HTTPURLResponse {
                            
                            if httpResponse.statusCode == 200 {
                                DispatchQueue.main.async {
                                    print("Stored Successfully")
                                    self.requestInProcessing = false
                                    if self.timeOutRetriesCount > 0 {
                                        self.timeOutRetriesCount = 0
                                    }
                                    // send back the temp data
                                    onSuccess()
                                }
                            }
                            else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                                DispatchQueue.main.async {
                                    if self.timeOutRetriesCount < 3 {
                                        self.timeOutRetriesCount += 1
                                        self.adminAuthModel.serverLogin()
                                        self.storeLikesDislikes(apiToBeUsed: apiToBeUsed,onFailure: onFailure,onSuccess:onSuccess, swipedUserId: swipedUserId, swipeInfo: swipeInfo)
                                    }
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
                        print("Error in API: \(error)")
                        onFailure()
                        return
                    }
                    
                    if let _ = data {
                        // Check if you receive a valid httpresponse
                        if let httpResponse = response as? HTTPURLResponse {
                            
                            if httpResponse.statusCode == 200 {
                                DispatchQueue.main.async {
                                    print("Stored Successfully")
                                    self.requestInProcessing = false
                                    if self.timeOutRetriesCount > 0 {
                                        self.timeOutRetriesCount = 0
                                    }
                                    // send back the temp data
                                    onSuccess()
                                }
                            }
                            else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                                DispatchQueue.main.async {
                                    if self.timeOutRetriesCount < 3 {
                                        self.timeOutRetriesCount += 1
                                        self.adminAuthModel.serverLogin()
                                        self.storeLikesDislikes(apiToBeUsed: apiToBeUsed,onFailure: onFailure,onSuccess:onSuccess, swipedUserId: swipedUserId, swipeInfo: swipeInfo)
                                    }
                                    self.requestInProcessing = false
                                }
                            }
                        }
                    }
                }.resume()
            }
        }
    }
    
    public static func undoLikeDislikeFirestore(apiToBeUsed:String, onFailure: @escaping () -> Void, onSuccess: @escaping () -> Void, swipedUserId: String?, swipeInfo: AllCardsView.LikeDislike) {
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
                        print("Error in API: \(error)")
                        onFailure()
                        return
                    }
                    
                    if let _ = data {
                        // Check if you receive a valid httpresponse
                        if let httpResponse = response as? HTTPURLResponse {
                            
                            if httpResponse.statusCode == 200 {
                                DispatchQueue.main.async {
                                    print("Rewind Operation Successful")
                                    self.requestInProcessing = false
                                    if self.timeOutRetriesCount > 0 {
                                        self.timeOutRetriesCount = 0
                                    }
                                    // send back the temp data
                                    onSuccess()
                                }
                            }
                            else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                                DispatchQueue.main.async {
                                    if self.timeOutRetriesCount < 3 {
                                        self.timeOutRetriesCount += 1
                                        self.adminAuthModel.serverLogin()
                                        self.storeLikesDislikes(apiToBeUsed: apiToBeUsed,onFailure: onFailure,onSuccess:onSuccess, swipedUserId: swipedUserId, swipeInfo: swipeInfo)
                                    }
                                    self.requestInProcessing = false
                                }
                            }
                        }
                    }
                }.resume()
            }
        }
    }
    
}
