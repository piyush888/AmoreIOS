//
//  NumberCode.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/24/21.
//

import SwiftUI
import Combine
import FirebaseAuth

struct LoginOTPKeyCodeParent: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    
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
                        Text("\(profileModel.phoneNumber)")
                            .foregroundColor(.pink)
                    }
                    
                    Spacer()
                    
                    Button {
                        profileModel.currentVerificationId = FirebaseServices.requestOtp(phoneNumber: profileModel.phoneNumber)
                    } label: {
                        Text("Send Again")
                         .foregroundColor(.black)
                    }
                }.padding(.top,20)
            }
            .padding(.top, 100)
            
            // OTP Text Field
            VStack(alignment: .center) {
                LoginOTPKeyCodeChild(verificationCode: $profileModel.verificationCode)
            }
            .padding(.top, 130)
            
            // OTP Submit button
            Button(action: {
                profileModel.signIn()
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
        .alert(isPresented: $profileModel.showAlert) {
            Alert(title: Text(""), message: Text("The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user."), dismissButton: .default(Text("OK")))
        }
        .padding(.horizontal,40)
    }
}


struct LoginOTPKeyCodeParent_Previews: PreviewProvider {
    static var previews: some View {
        LoginOTPKeyCodeParent(otpGeneratedOnce: Binding.constant(true))
    }
}
