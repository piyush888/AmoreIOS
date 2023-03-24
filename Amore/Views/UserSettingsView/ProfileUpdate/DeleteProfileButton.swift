//
//  DeleteProfileButton.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/25/21.
//

import SwiftUI

struct DeleteProfileButton: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    
    var body: some View {
        
        NavigationLink {
            DeleteDisableView()
                .environmentObject(profileModel)
                .environmentObject(photoModel)
                .environmentObject(adminAuthenticationModel)
        } label: {
            Button{
                // TODO
            } label : {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("Delete Account")
                }
                .foregroundColor(.pink)
            }
        }
        
    }
}

struct DeleteProfileButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteProfileButton()
            .environmentObject(ProfileViewModel())
            .environmentObject(PhotoModel())
            .environmentObject(AdminAuthenticationViewModel())
    }
}
