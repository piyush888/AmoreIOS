//
//  EditProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/22/21.
//

import SwiftUI
import Firebase

struct EditProfile: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @Binding var profileEditingToBeDone: Bool
    @State var currentPage: EditOrPreviewProfile = .editProfile
    @State var headingName = "Edit Info"
    @State private var showSheetView = false
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                
                HStack {
                    
                    Button {
                        self.showSheetView.toggle()
                    } label: {
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing)
                            .frame(width:30, height:35)
                            .mask(Image(systemName: "bonjour")
                                    .imageScale(.large))
                            .padding(.bottom,20)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Take Back to Profile View
                        profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid)
                        profileEditingToBeDone = false
                    }) {
                    HStack {
                        Text("Done")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("dark-green"), Color("light-green")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(20)
                    }
                    
                }.padding(.horizontal,20)
                
                HStack {
                    Spacer()
                    
                    
                    VStack(alignment: .leading) {
                          Text("Edit Info")
                            .font(.subheadline)
                            .padding()
                        }
                        .frame(
                          minWidth: 0,
                          maxWidth: geometry.size.width/3
                        )
                        .background(headingName == "Edit Info" ? Color(hex: 0xe8f4f8) : .white)
                        .cornerRadius(20.0)
                        .onTapGesture {
                            currentPage = .editProfile
                            headingName = "Edit Info"
                        }
                        .overlay(
                               RoundedRectangle(cornerRadius: 16)
                                .stroke(headingName == "Edit Info" ? Color.clear :Color(hex: 0xe8f4f8), lineWidth: 0.5)
                        )
                    
                    
                    Spacer()
                    
                    
                    VStack(alignment: .leading) {
                          Text("Preview Profile")
                            .font(.subheadline)
                            .padding()
                        }
                        .frame(
                          minWidth: 0,
                          maxWidth: geometry.size.width/3
                        )
                        .background(headingName == "Preview Profile" ? Color(hex: 0xe8f4f8) :.white)
                        .cornerRadius(20.0)
                        .onTapGesture {
                            currentPage = .previewProfile
                            headingName = "Preview Profile"
                        }
                        .overlay(
                               RoundedRectangle(cornerRadius: 16)
                                .stroke(headingName == "Preview Profile" ? Color.clear :Color(hex: 0xe8f4f8), lineWidth: 0.5)
                        )
                    
                    
                    Spacer()
                }
                
                switch currentPage {
                    
                    case .editProfile:
                        EditCardInfo()
                            .environmentObject(photoModel)
                            .environmentObject(profileModel)
                        
                    case .previewProfile:
                        PreviewProfile()
                            .environmentObject(photoModel)
                            .environmentObject(profileModel)
                }
                
                Spacer()
            }
            .padding(.top)
            .navigationBarHidden(true)
            .sheet(isPresented: $showSheetView) {
                MoreInfoForBetterMatch(showSheetView:$showSheetView)
            }
        }
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile(profileEditingToBeDone: Binding.constant(true))
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
    }
}
