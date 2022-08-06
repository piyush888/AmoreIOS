////
////  LogInSheetView.swift
////  Amore
////
////  Created by Kshitiz Sharma on 10/16/21.
////
//
//import SwiftUI
//import FirebaseAuth
//
//struct LogInSheetView: View {
//
//    @Environment(\.colorScheme) var colorScheme
//    @EnvironmentObject var profileModel: ProfileViewModel
//    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
//
//
//    var body: some View {
//
//        VStack{
//            Button{
//                profileModel.loginFormVisible = true
//            } label : {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 15)
////                        .foregroundColor(colorScheme == .dark ? Color.yellow : Color.pink)
//                        .foregroundColor(Color.pink)
//                        .frame(height:60)
//
//                    Text("Sign In/Sign Up")
//                        .bold()
//                        .padding(.horizontal,20)
////                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
//                        .foregroundColor(Color.white)
//                }
//            }
////            .sheet(isPresented: $profileModel.loginFormVisible, onDismiss: {
////                profileModel.checkLogin()
////            }) {
////                LoginPhoneNumber()
////                    .environmentObject(profileModel)
////                    .environmentObject(adminAuthenticationModel)
////            }
//        }
//        .padding(.horizontal,44)
//
//    }
//
//}
//
//struct LogInSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            LogInSheetView()
//                .environmentObject(ProfileViewModel())
//            .environmentObject(AdminAuthenticationViewModel())
//            LogInSheetView()
//                .environmentObject(ProfileViewModel())
//                .environmentObject(AdminAuthenticationViewModel())
//        }
//    }
//}
