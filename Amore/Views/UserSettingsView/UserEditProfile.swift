//
//  EditProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/22/21.
//

import SwiftUI

struct EditProfile: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    
    @State var user = User(id: 0, firstName: "Cindy", lastName: "Jones", age: 23, profileDistanceFromUser: 4, imageName1: "girl1_image1",imageName2: "girl1_image2",imageName3: "girl1_image3",imageName4: "girl1_image4",imageName5: "girl1_image5",imageName6: "girl1_image6", occupation: "Coach", passions: ["Photography", "Shopping"], height: "5 55", education:"Bachelor",religion:"Hindu",politics:"Liberal", location:"Texas, US", description:"You are strong because you are imperfect, you have doubts because you are wise")
    
    
    @State var currentPage: EditOrPreviewProfile = .editProfile
    @State var headingName = "Edit Info"
    
    var body: some View {
        
        VStack {
            
            HStack {
                Spacer()
                
//                Text("\(headingName)")
//                    .font(.title2)
//                    .multilineTextAlignment(.center)
//
//                Spacer()
//
                Button {
                    // Take Back to Profile View
                } label: {
                    Text("Done")
                        .font(.title2)
                        .foregroundColor(.pink)
                }
                
            }
            
            HStack {
                Spacer()
                Text("Edit")
                    .font(.title2)
                    .foregroundColor(headingName == "Edit Info" ? .red : .gray)
                    .onTapGesture {
                        currentPage = .editProfile
                        headingName = "Edit Info"
                    }
                    
                Spacer()
                
                Text("Preview")
                    .font(.title2)
                    .foregroundColor(headingName == "Preview Profile" ? .red : .gray)
                    .onTapGesture {
                        currentPage = .previewProfile
                        headingName = "Preview Profile"
                    }
                Spacer()
            }
            
            switch currentPage {
                
                case .editProfile:
                    EditCardInfo()
                
                case .previewProfile:
                    PreviewProfile(user:user)
                
                
            }
            
            Spacer()
        }
        .padding(.horizontal,20)
        .padding(.top)
        .navigationBarHidden(true)
        
//        UserProfilePhotosView()
//            .environmentObject(photoModel)
        
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
            .environmentObject(PhotoModel())
    }
}
