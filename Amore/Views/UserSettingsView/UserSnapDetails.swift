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
    @State var geometry: GeometryProxy
    
    var body: some View {
        
        VStack {
            CardImages(profileImage: profileModel.editUserProfile.image1,
                       width:geometry.size.height/4.0,
                       height: geometry.size.height/4.0)
            .frame(height: geometry.size.height/4.0)
            .clipShape(Circle())
            .shadow(color: Color.pink, radius: 5, x: 0.5, y: 0.5)

            
            Text("\(profileModel.editUserProfile.firstName ?? "Kshitiz"), \(profileModel.editUserProfile.age ?? 25)")
                .font(.title2)
            
            Text("\(profileModel.editUserProfile.jobTitle ?? "Software Developer") at \(profileModel.editUserProfile.work ?? "Amore")")
                .font(.caption)
            
            Text("Attended \(profileModel.editUserProfile.school ?? "Brightlands School")")
                .font(.caption)
            
            Spacer()
        }
        
    }
}

//struct UserSnapDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        UserSnapDetails(circularImageSize:400)
//    }
//}
