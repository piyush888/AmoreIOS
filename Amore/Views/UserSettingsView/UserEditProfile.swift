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
    
    var body: some View {
        
        VStack {
            
            HStack {
                Spacer()
                switch currentPage {
                    case .editProfile:
                        Text("Edit Info")
                        
                    case .previewProfile:
                        Text("Preview")
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Done")
                }
                
            }
            
            HStack {
                Spacer()
                Text("Edit Info")
                    .onTapGesture {
                        currentPage = .editProfile
                    }
                    
                Spacer()
                
                Text("Preview Profile")
                    .onTapGesture {
                        currentPage = .previewProfile
                    }
                Spacer()
            }
            
            switch currentPage {
                
                case .editProfile:
                    Text("Edit Profile")
                
                case .previewProfile:
                    Text("Preview Profile")
                
            }
            
            Spacer()
        }
        .padding(.horizontal,20)
        .padding(.top)
        
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
