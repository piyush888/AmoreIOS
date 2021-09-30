//
//  FirebaseServices.swift
//  Amore
//
//  Created by Piyush Garg on 27/09/21.
//

import Foundation
import FirebaseAuth

class FirebaseServices {
    
    static func requestOtp(phoneNumber: String) -> String {
        var currentVerificationId = ""
        // Step 3 (Optional) - Default language is English
        Auth.auth().languageCode = "en"
        
        // Step 4: Request SMS
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("$$$$$"+error.localizedDescription)
                return
            }
            if let ver = verificationID {
                print("$$$"+ver)
            }
            
            // Either received APNs or user has passed the reCAPTCHA
            // Step 5: Verification ID is saved for later use for verifying OTP with phone number
            currentVerificationId = verificationID!
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        }
        return currentVerificationId
    }
    
}
