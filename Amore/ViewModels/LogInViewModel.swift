//
//  LogInViewModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/16/21.
//

import SwiftUI
import Firebase


class LoginViewModel: ObservableObject {

    // Logi Properties...
    @Published var countryCode = ""
    @Published var phNumber = ""
    
    // Alert...
    @Published var showAlert = false
    @Published var errorMsg = ""
    
    // Verification ID
    @Published var ID = ""
    
    // Loading...
    @Published var isLoading = false
    
    @AppStorage("log_Status") var logStatus = false
    @AppStorage("userName") var storedUser = ""
    @Published var newUser = false
    
    func verifyUser(){
        
        withAnimation{isLoading = true}
        
        // Undo this if testing with real devices or real ph Numbers...
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        // Sending Otp And Verifying user...
        PhoneAuthProvider.provider().verifyPhoneNumber("+\(countryCode + phNumber)", uiDelegate: nil) { ID, err in
            
            if let error = err{
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                return
            }
            
            self.ID = ID!
            self.alertWithTF()
        }
    }
    
    // Alert With TextField For OTP Code...
    func alertWithTF(){
        
        let alert = UIAlertController(title: "Verification", message: "Enter OTP Code", preferredStyle: .alert)
        
        alert.addTextField { txt in
            txt.placeholder = "123456"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            
            if let code = alert.textFields?[0].text{
                self.LoginUser(code: code)
            }
            else{
                self.reportError()
            }
            
        }))
        
        // presenting Alert View...
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // Loggin in User...
    func LoginUser(code: String){
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { result, err in
            if let error = err{
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                return
            }
            
            // user Successfully Logged In....
            print("success")
        }
    }
    
    // Reporting Error...
    func reportError(){
        self.errorMsg = "Please try again later !!!"
        self.showAlert.toggle()
    }
}

