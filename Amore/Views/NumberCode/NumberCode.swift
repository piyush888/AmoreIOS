//
//  NumberCode.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/24/21.
//

import SwiftUI
import Combine
import FirebaseAuth

struct NumberCode: View {
    
    @Binding var phoneNumber: String
    @Binding var verification_Id : String
    @State var verificationCode: String = ""
    @State var authErrorDesc: String?
    @State var errorDesc = Text("")
    @Binding var loginFormVisible: Bool
    @Binding var otpGeneratedOnce: Bool
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .leading) {
                Text("Type the verification code we've sent ")
                    .font(.BoardingTitle)
                    .padding(.bottom, 10)
                
                HStack {
                        
                    Button {
                        otpGeneratedOnce = false
                    } label: {
                        Text("\(phoneNumber)")
                            .foregroundColor(.pink)
                    }
                    
                    Spacer()
                    
                    Button {
                        verification_Id = FirebaseServices.requestOtp(phoneNumber: self.phoneNumber)
                    } label: {
                        Text("Send Again")
                         .foregroundColor(.black)
                    }
                }.padding(.top,20)
                
                
                
            }
            .padding(.top, 100)
            
            // OTP Text Field
            VStack(alignment: .center) {
                
//                TextField("0000", text: $pin)
//                    .keyboardType(.numberPad)
//                    .font(Font.custom("Sk-Modernist-Bold", size: 40))
//                    .onReceive(Just(pin)) { newValue in
//                        let filtered = newValue.filter { "0123456789".contains($0) }
//                        if filtered != newValue {
//                            self.pin = filtered
//                    }
//                }
//
                OTPKeyCode(verificationCode: $verificationCode)
            }
            .padding(.top, 130)
            
            if authErrorDesc != nil {
                Section {
                    Text(authErrorDesc!)
                }
            }
            
            // OTP Submit button
            Button(action: {
                signIn()
                
            }) {
                ZStack{
                    Rectangle()
                        .frame(height:45)
                        .cornerRadius(5.0)
                        .foregroundColor(.pink)
                    
                    Text("Log In")
                        .foregroundColor(.white)
                        .bold()
                        .font(.BoardingButton)
                }
            }
            .padding(.top, 80)
            Spacer()
        }
        .padding(.horizontal,130)
        
    }
    
    func signIn (){

        if let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") {
            print(verificationID+" in sign in!")
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)

            Auth.auth().signIn(with: credential) { (authResult, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        let authError = error as NSError
                        print(authError.localizedDescription)
                        authErrorDesc =  authError.localizedDescription
                    }
                    else {
                        loginFormVisible = false
                    }
                }
            }
        }
    }
}


struct NumberCode_Previews: PreviewProvider {
    static var previews: some View {
        NumberCode(phoneNumber: Binding.constant("551697188"), verification_Id: Binding.constant("551697188"), loginFormVisible: Binding.constant(false), otpGeneratedOnce: Binding.constant(true))
    }
}
