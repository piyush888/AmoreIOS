//
//  FirebaseServices.swift
//  Amore
//
//  Created by Piyush Garg on 27/09/21.
//

import Foundation
import FirebaseAuth

class FirebaseServices: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var verificationCode: String = ""
    @Published var navigationTag: String?
    
    func requestOtp(phoneNumber: String) {
        if isLoading{return}
        
        // Step 3 (Optional) - Default language is English
        Auth.auth().languageCode = "en"
        // Step 4: Request SMS
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error in requestOTP"+error.localizedDescription)
                    self.isLoading = false
                }
                if let verId = verificationID {
                    self.verificationCode = verId
                    self.navigationTag = "VERIFICATION"
                    self.isLoading = false
                    print("requestOTP Verification success"+verId)
                }
                // Either received APNs or user has passed the reCAPTCHA
                // Step 5: Verification ID is saved for later use for verifying OTP with phone number
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            }
        }
        
    }
    
}
