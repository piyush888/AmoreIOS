//
//  EditProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/22/21.
//

import SwiftUI

struct EditProfile: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    
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
                    PreviewProfile()
                
                
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
