//
//  UserSnapDetails.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/30/21.
//

import SwiftUI

struct UserSnapDetails: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var photoModel: PhotoModel
    
    var body: some View {
        
        VStack {
            Image(uiImage: photoModel.downloadedPhotos.count == Array(Set(photoModel.downloadedPhotosURLs)).count ? photoModel.downloadedPhotos.sorted { $0.id! < $1.id! }[0].image! : UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200, alignment: .center)
                .clipShape(Circle())
                .shadow(color: Color.pink, radius: 5, x: 0.5, y: 0.5)
            
            
            Text("\(profileModel.userProfile.firstName ?? "Kshitiz"), \(profileModel.userProfile.age ?? 25)")
                .font(.title2)
            
            Text("\(profileModel.userProfile.jobTitle ?? "Software Developer") at \(profileModel.userProfile.work ?? "Amore")")
                .font(.caption)
            
            Text("Attended \(profileModel.userProfile.school ?? "Brightlands School")")
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
