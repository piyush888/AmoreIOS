//
//  UserSnapDetails.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/30/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserSnapDetails: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var photoModel: PhotoModel
    
    var body: some View {
        
        VStack {
            ProfileImageView(profileImage: $profileModel.editUserProfile.image1,
                             photo: $photoModel.photo1,
                             width:200,
                             height: 200)
                            .scaledToFill()
                            .clipShape(Circle())
                            .shadow(color: Color.pink, radius: 5, x: 0.5, y: 0.5)
            
            Text("\(profileModel.editUserProfile.firstName ?? "Kshitiz"), \(profileModel.editUserProfile.age ?? 25)")
                .font(.title2)
            
            Text("\(profileModel.editUserProfile.jobTitle ?? "Software Developer") at \(profileModel.editUserProfile.work ?? "Amore")")
                .font(.caption)
            
            Text("Attended \(profileModel.editUserProfile.school ?? "Brightlands School")")
                .font(.caption)
            
            Spacer()
        }.padding(.top,50)
        
    }
}

struct UserSnapDetails_Previews: PreviewProvider {
    static var previews: some View {
        UserSnapDetails()
    }
}
