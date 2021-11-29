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
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        // Take Back to Profile View
                        profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid)
                        profileEditingToBeDone = false
                    } label: {
                        
                        VStack(alignment: .leading) {
                              Text("Done")
                                .font(.subheadline)
                                .padding()
                                .foregroundColor(.white)
                            }
                            .frame(
                              minWidth: 0,
                              maxWidth: geometry.size.width/5
                            )
                            .background(Color.blue)
                            .cornerRadius(20.0)
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
