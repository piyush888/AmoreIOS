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
    
    @EnvironmentObject var firebaseSvcObj: FirebaseServices
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    @StateObject var otpViewModel = OTPViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
            VStack {
                    
                    // Verification headline
                    // "Please enter the OTP..." comment
                    viewHeader
                        .padding(.top, 30)
                        .padding(.bottom, 100)
                        .onTapGesture {
                            self.hideKeyboard()
                        }
                    
                    // OTP Text Field
                    VStack(alignment: .center) {
//                        LoginOTPKeyCodeChild(otpVerificationCode: $otpVerificationCode)
                        LoginOTPKeyCodeChild()
                            .environmentObject(otpViewModel)
                    }
                    
                    // OTP Submit button
                    submitFormButton
                        .padding(.top, 50)
                    
                    // Send again button
                    sendAgainButton
                    
                    Spacer()
                }
            .alert(isPresented: $profileModel.showAlert) {
                Alert(title: Text("Incorrect OTP"),
                      message: Text("The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user."), dismissButton: .default(Text("OK"))
                )
            }
            .padding(.horizontal,20)
            .navigationBarTitle("Verify OTP")
            .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    
    var viewHeader: some View {
        VStack(alignment:.leading) {

            Text("Please enter the OTP sent to your number \(profileModel.phoneNumber) to complete the verification")
                .font(.body)
                .multilineTextAlignment(.leading)
                .foregroundColor(colorScheme == .dark ? Color.white: Color.gray)
        }
    }
    
    // button to send the OTP again
    var sendAgainButton: some View {
        
        Button {
            firebaseSvcObj.requestOtp(phoneNumber: profileModel.phoneNumber)
        } label: {
                
                HStack {
                    Image(systemName:"repeat.circle.fill")
                        .resizable()
                        .frame(width:30,height:30)
                    Text("Re-send OTP")
                }
                .padding(.top,10)
        }
    }
    
    
    // OTP Submit button
    var submitFormButton: some View {
        Button(action: {
            profileModel.signIn(adminAuthenticationObj: adminAuthenticationModel,
                                otpVerificationCode: otpViewModel.otpVerificationCode)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    // TODO - Change the color of button when deactivate and activate
                    .foregroundColor(Color.pink)
                    .frame(width:150, height:50)
            
                Text("Log In")
                    .bold()
                    .foregroundColor(.white)
            }
        }
        // Deactivate
        .disabled(otpViewModel.otp6 == "" ? true:false)
        
    }
    
    
}


struct LoginOTPKeyCodeParent_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ForEach(ColorScheme.allCases, id: \.self) {
                LoginOTPKeyCodeParent()
                    .preferredColorScheme($0)
                    .environmentObject(ProfileViewModel())
                    .environmentObject(AdminAuthenticationViewModel())
            }
        }
    }
}
