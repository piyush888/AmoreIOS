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
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    @StateObject var firebaseSvcObj = FirebaseServices()
    @Environment(\.colorScheme) var colorScheme
    
    let phoneNumberKit = PhoneNumberKit()
    
    @State private var validationError = false
    @State private var errorDesc = Text("")
    
    var body: some View {
        
        if #available(iOS 15.0, *) {
            phoneNumberBody
            .background{
                otpNavigationLink
            }
        } else {
            Group {
                phoneNumberBody
                otpNavigationLink
            }
        }
        
    }
    
    var phoneNumberBody: some View {
        VStack {
            
            // Please enter your phone number and image
            Group {
                Text("Please enter your phone number")
                    .foregroundColor(colorScheme == .dark ? Color.white: Color.gray)
                
                Image("Fingerprint-cuate")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300, alignment: .center)
            }
            .onTapGesture {
                self.hideKeyboard()
            }
            
            // Image and the grey text
            VStack {
                // Iphone number field and go to the next move forward button
                HStack {
                    iPhoneNumberField(text: $profileModel.phoneNumber)
                        .flagHidden(false)
                        .flagSelectable(true)
                        .clearButtonMode(.whileEditing)
                        .onNumberChange(perform: { inputNum in
                            profileModel.countryCode = String(inputNum?.countryCode ?? 1)
                        })
                        .frame(height:50)
                        .padding(.leading,10)
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .cornerRadius(10)
                        .shadow(color: .pink, radius: 3)
                    
                    
                    // Navigate to the OTP View
                    sendOTPButton
                
                }
                .padding(.vertical, 20)
                
                Text("We will send you a 6-digit code to verify your account")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                
            }
            
            
            Spacer()
        }
        .padding(.horizontal,40)
        .padding(.top,25)
        .alert(isPresented: self.$validationError) {
            Alert(title: Text(""), message: self.errorDesc, dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle("Verification")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var otpNavigationLink: some View {
        NavigationLink(tag: "VERIFICATION", selection: $firebaseSvcObj.navigationTag) {
            LoginOTPKeyCodeParent()
                .environmentObject(firebaseSvcObj)
        } label: {}
        .labelsHidden()
    }
    
    
    var sendOTPButton: some View {
        
        // Continue button to OTR{
        Button {
            DispatchQueue.main.async {
                do {
                    profileModel.phoneNumber = profileModel.phoneNumber.replacingOccurrences(of: " ", with: "")
                    profileModel.phoneNumber = profileModel.phoneNumber.replacingOccurrences(of: "[\\(\\)-]", with: "", options: .regularExpression, range: nil)
                    if !profileModel.phoneNumber.hasPrefix("+") {
                        profileModel.phoneNumber = "+" + profileModel.countryCode + profileModel.phoneNumber
                    }
                    print(profileModel.phoneNumber)
                    _ = try self.phoneNumberKit.parse(profileModel.phoneNumber)
                    // Integrate with firebase signup/login system here when no error occurs
                    firebaseSvcObj.requestOtp(phoneNumber: profileModel.phoneNumber)
                } catch {
                    print(error.localizedDescription)
                    self.validationError = true
                    self.errorDesc = Text("Please enter a valid phone number")
                }
            }
        } label: {
            buttonDesign
        }
        .disabled(profileModel.phoneNumber == "")
        .opacity(profileModel.phoneNumber == "" ? 0.4 : 1)
    }
    
    var buttonDesign: some View {
            Image(systemName: "arrow.forward.circle.fill")
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(Color.green)
     }
    
}


struct LoginPhoneNumber_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ForEach(ColorScheme.allCases, id: \.self) {
            LoginPhoneNumber()
                .preferredColorScheme($0)
                .environmentObject(ProfileViewModel())
        }
        
    }
}
