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
    
    @Published var cookieSet = false
    
    var apiURL = "http://127.0.0.1:5000"
    
    // Authenticate the user in the backend
    /// Makes use of Client ID Token, This token will be sent to backend to authenticate the client to backend
    /// If Successfully authenticated the api will send back cookies which will be store in HTTPCookieStorage.shared
    /// These shared cookies are available through out the application & will be auto appended to any request on that domain
    /// To get cookies for the url try following command: po HTTPCookieStorage.shared.cookies(for:URL(string: self.apiURL)!)
    func serverLogin() {
        
        // Access the logged in user here.
        let currentUser = Auth.auth().currentUser
        
        // Get the Client Token ID
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                print(error)
                return;
            }
            
            // sessionLogin is the api where the user will be authenticated
            guard let url = URL(string: self.apiURL + "/sessionLogin") else { return }
            // add the pay load to the request
            let body: [String: String] = ["idToken": idToken!]
            
            let finalBody = try! JSONSerialization.data(withJSONObject: body)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = finalBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // Call the api
            URLSession.shared.dataTask(with: request) { (data, response, error) in
               // Check if data exist in the response back
               if let data = data {
                   // Check if you receive a valid httpresponse
                   if let httpResponse = response as? HTTPURLResponse {
                     do {
                       // A user is only authenticated when it returns code 200
                       if httpResponse.statusCode == 200 {
                           // Decode the data sent back from the flask api. This will contain message and a custom statuscode
                           let decodedResponse = try JSONDecoder().decode(ServerMessage.self, from: data)
                           DispatchQueue.main.async {
                                guard
                                    let url = response?.url,
                                    // this is all the fields received in the response header + cookies
                                    // below creates a dictionary of those fields
                                    let fields = httpResponse.allHeaderFields as? [String: String]
                                else { return }
                                // creates array of cookies. we have only one cookie, so it will only be one cookie for us
                                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
                                // if the cookie exist it will be added to the HTTPCookieStorage storage
                                HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
                                for cookie in cookies {
                                        var cookieProperties = [HTTPCookiePropertyKey: Any]()
                                        cookieProperties[.name] = cookie.name
                                        cookieProperties[.value] = cookie.value
                                        cookieProperties[.domain] = cookie.domain
                                        cookieProperties[.path] = cookie.path
                                        cookieProperties[.version] = cookie.version
                                        cookieProperties[.expires] = cookie.expiresDate

                                        let newCookie = HTTPCookie(properties: cookieProperties)
                                        HTTPCookieStorage.shared.setCookie(newCookie!)
                                        //print("name: \(cookie.name) value: \(cookie.value)")
                                    }
                                // We set a custom flag for us that cookie was set
                                self.cookieSet = true
                            }
                       } else {
                           // If the response fails from the backend we will get 401, 400 or 500 status code
                           print(httpResponse.statusCode)
                       }
                     } catch let jsonError as NSError {
                       print("JSON decode failed: \(jsonError.localizedDescription)")
                     }
                     return
                   }
               }
           }.resume()

        }
    }
    
    
}



