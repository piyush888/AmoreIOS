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
    @State var selectedTab = "Edit Info"
    @State private var showSheetView = false
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                
                // Done Button
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
                        Text("Done")
                    }
                }.padding(.horizontal,20)
               
                
                // Tab Buttons
                HStack {
                    Spacer()

                    EditProfileButtons(buttonName:"Edit Info",
                                       selectedTab:$selectedTab)
                    .onTapGesture {
                        currentPage = .editProfile
                        selectedTab = "Edit Info"
                    }
                    .padding(.horizontal,20)

                    Spacer()

                    EditProfileButtons(buttonName:"Preview Profile",
                                       selectedTab:$selectedTab)
                    .onTapGesture {
                        currentPage = .previewProfile
                        selectedTab = "Preview Profile"
                    }
                    .padding(.horizontal,20)

                    Spacer()
                }

                // Tab Views
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

struct EditProfileButtons: View {
    @Environment(\.colorScheme) var colorScheme
    @State var currentPage: EditOrPreviewProfile = .editProfile
    @State var buttonName: String
    @Binding var selectedTab: String
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(selectedTab == buttonName ? Color.blue : (colorScheme == .dark ? Color(hex: 0x24244A) : Color(hex: 0xe8f4f8)))
                .frame(height:40)
                
            Text(buttonName)
                .font(.subheadline)
                .padding(.horizontal,20)
                .foregroundColor(selectedTab == buttonName ? Color.white : .accentColor)
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


