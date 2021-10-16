//
//  Number.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/24/21.
//

import iPhoneNumberField
import PhoneNumberKit
import SwiftUI
import FirebaseAuth


struct LoginPhoneNumber: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    
    let phoneNumberKit = PhoneNumberKit()
    
    @State private var validationError = false
    @State private var errorDesc = Text("")
    @State private var otpGeneratedOnce = false
    
    var body: some View {
        
        NavigationView {
            VStack(alignment:.leading) {
                Text("My number is")
                    .font(.BoardingTitle)
                    .padding(.bottom,20)
                
                Text("Please enter your valid phone number. We will send you a 6-digit code to verify your account")
                    .font(.BoardingSubHeading)
                    .padding(.bottom,40)
                
                VStack{
                    iPhoneNumberField(text: $profileModel.phoneNumber)
                        .flagHidden(false)
                        .flagSelectable(true)
                        .onNumberChange(perform: { inputNum in
                            profileModel.countryCode = String(inputNum?.countryCode ?? 91)
                        })
                        .font(UIFont(size: 20, design: .rounded))
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.pink, lineWidth: 1))
                    NavigationLink(
                        destination: LoginOTPKeyCodeParent(otpGeneratedOnce: $otpGeneratedOnce),
                        isActive: $otpGeneratedOnce,
                        label: {
                            Button(action: {
                                do {
                                    _ = try self.phoneNumberKit.parse(profileModel.phoneNumber)
                                    if !profileModel.phoneNumber.hasPrefix("+") {
                                        profileModel.phoneNumber = "+" + profileModel.countryCode + profileModel.phoneNumber
                                    }
                                    profileModel.phoneNumber = profileModel.phoneNumber.replacingOccurrences(of: "[\\(\\)-]", with: "", options: .regularExpression, range: nil)
                                    profileModel.phoneNumber = profileModel.phoneNumber.replacingOccurrences(of: " ", with: "")
                                    print(profileModel.phoneNumber)
                                    // Integrate with firebase signup/login system here when no error occurs
                                    profileModel.currentVerificationId = FirebaseServices.requestOtp(phoneNumber: profileModel.phoneNumber)
                                    otpGeneratedOnce = true
                                } catch {
                                    self.validationError = true
                                    self.errorDesc = Text("Please enter a valid phone number")
                                }
                            }) {
                                ZStack{
                                    Rectangle()
                                        .frame(height:45)
                                        .cornerRadius(5.0)
                                        .foregroundColor(.pink)
                                    
                                    Text("Continue")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(.BoardingButton)
                                }
                            }
                            .padding(.top, 80)
                        })
                    
                }
                .alert(isPresented: self.$validationError) {
                    Alert(title: Text(""), message: self.errorDesc, dismissButton: .default(Text("OK")))
                }
                
            }.padding(.horizontal,40)
            .navigationBarHidden(true)
        }
    }
}


struct LoginPhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
        LoginPhoneNumber()
    }
}
