//
//  LogInSheetView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/16/21.
//

import SwiftUI
import FirebaseAuth

struct LogInSheetView: View {
    
    @AppStorage("log_Status") var logStatus = false
    
    @EnvironmentObject var profileModel: ProfileViewModel
//    @EnvironmentObject var streamModel: StreamViewModel
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    
    var body: some View {
        
        VStack{
            Button{
                profileModel.loginFormVisible = true
            } label : {
                ZStack{
                    Rectangle()
                        .frame(height:45)
                        .cornerRadius(5.0)
                        .foregroundColor(.pink)
                        .padding(.horizontal,44)
                    
                    Text("Sign In/Sign Up")
                        .foregroundColor(.white)
                        .bold()
                        .font(.BoardingButton)
                }
            }
            .sheet(isPresented: $profileModel.loginFormVisible, onDismiss: {
                profileModel.checkLogin()
            }) {
                LoginPhoneNumber()
                    .environmentObject(profileModel)
//                    .environmentObject(streamModel)
                    .environmentObject(adminAuthenticationModel)
            }
        }
        .padding(.horizontal,44)
        .padding(.bottom,44)
        
    }
    
}

struct LogInSheetView_Previews: PreviewProvider {
    static var previews: some View {
        LogInSheetView()
    }
}
