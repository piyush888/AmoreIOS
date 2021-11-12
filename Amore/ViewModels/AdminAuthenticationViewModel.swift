//
//  AdminAuthenticationViewModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/12/21.
//

import SwiftUI
import FirebaseAuth

struct ServerMessage: Decodable {
   let message: String
   let statusCode: Int
}

class AdminAuthenticationViewModel: ObservableObject {
        
    // Alert....
    @Published var showAlert = false
    @Published var errorMsg = ""
    
    @Published var authenticated = false
    
    
    var stringURL = "http://127.0.0.1:5000"
    
    // Authenticate the user in the backend
    func adminLogin() {
                
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                print(error)
                return;
            }

            guard let url = URL(string: self.stringURL + "/adminLogin") else { return }
            let body: [String: String] = ["idToken": idToken!]
            
            let finalBody = try! JSONSerialization.data(withJSONObject: body)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = finalBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

           URLSession.shared.dataTask(with: request) { (data, response, error) in
               
               if let data = data {
                 do {
                   let decodedResponse = try JSONDecoder().decode([ServerMessage].self, from: data)
                   if decodedResponse[0].statusCode == 200 {
                        DispatchQueue.main.async {
                             self.authenticated = true
                            print(decodedResponse[0].statusCode, decodedResponse[0].message)
                        }
                   } else {
                       print(decodedResponse[0].statusCode, decodedResponse[0].message)
                   }
                 } catch let jsonError as NSError {
                   print("JSON decode failed: \(jsonError.localizedDescription)")
                 }
                 return
               }
           }.resume()

        }
    }
}



