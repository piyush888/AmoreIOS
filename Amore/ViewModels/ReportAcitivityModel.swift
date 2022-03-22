//
//  ReportAcitivity.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/21/21.
//

import Foundation
import Firebase

class ReportActivityModel: ObservableObject  {

    @Published var fetchDataObj = FetchDataModel()
    
    static func reportUserWithReason(otherUserId:String, reason:String, description:String, onFailure: @escaping () -> Void, onSuccess: @escaping () -> Void) {
        
        var requestBody = ["current_user_id": Auth.auth().currentUser?.uid, "other_user_id": otherUserId,
                           "reasonGiven": reason,
                           "descriptionGiven": description]
        
        guard let url = URL(string: "http://127.0.0.1:5000/reportProfile") else { onFailure()
                return
        }
        let finalBody = try! JSONSerialization.data(withJSONObject: requestBody)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var tempData = ""
        
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
//                                tempData =  try JSONDecoder().decode(from: data)
                                print(data)
                            }
                            catch let jsonError as NSError {
                              print("JSON decode failed: \(jsonError.localizedDescription)")
                            }
                            // send back the temp data
                            onSuccess()
                        }
                    }
                    else if [400, 401, 403, 404, 500].contains(httpResponse.statusCode) {
                        onFailure()
                    }
                }
            }
        }.resume()
        
    }
    
}
