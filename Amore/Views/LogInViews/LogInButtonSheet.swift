//
//  LogInSheetView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/16/21.
//

import SwiftUI
import FirebaseAuth

struct LogInSheetView: View {
    
    @State var loginFormVisible = false
    @EnvironmentObject var profileModel: ProfileViewModel
    @Binding var loggedIn: Bool
    
    func checkLogin() {
        loggedIn = Auth.auth().currentUser == nil ? false : true
        print("Logged In: "+String(loggedIn))
    }
    
    var body: some View {
        
        VStack{
            Button{
                loginFormVisible = true
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
            .sheet(isPresented: $loginFormVisible, onDismiss: {
                checkLogin()
            }) {
                LoginPhoneNumber(loginFormVisible: $loginFormVisible)
                    .environmentObject(profileModel)
            }
        }
        .padding(.horizontal,44)
        .padding(.bottom,44)
        
    }
    
}

struct LogInSheetView_Previews: PreviewProvider {
    static var previews: some View {
        LogInSheetView(loggedIn: Binding.constant(false))
    }
}
