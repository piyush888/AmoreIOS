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
            .overlay(
                    Circle()
                        .stroke(Color.yellow,lineWidth: 4)
                        .overlay(
                            Image(systemName: "crown.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.yellow)
                                .frame(width: 30, height: 30)
                                .padding(10)
                                .background(Color.white)
                                .clipShape(Circle())
                                .offset(x: geometry.size.width/8.0, y: -geometry.size.height/8.0)
                        )
                )

            
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
//
struct UserSnapDetails_Previews: PreviewProvider {

    static var previews: some View {
        let profileModel = ProfileViewModel()
        
        profileModel.editUserProfile = Profile(id: "Test123456",  //can't be nil
                                           firstName: "Neha", //can't be nil
                                           lastName: "Sharma",  //can't be nil
                                           dateOfBirth: Date(),  //can't be nil
                                           interests: ["Running","Gaming","Helping"],  //can't be nil
                                           sexualOrientation: ["Straight"], // * show sexual orientation if visible is true
                                           sexualOrientationVisible: true,
                                           showMePreference: "Women", // Don't show
                                           work: "Bank of America", // Give in info. Below Passions
                                           school: "Harvard University", // Show the university name
                                           age: 25, // Age is shown already
                                           headline: "Hey Pumpkin",
                                           profileDistanceFromUser: 0,
                                           jobTitle: "VP",
                                           careerField: "Company Name", // *
                                           height: 5.6,
                                           education: "Masters in Science",
                                           religion: "Hindu",
                                           community: "Brahmin",
                                           politics: "Liberal",
                                           location: Location(longitude: 0.0, latitude: 0.0),
                                           description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                           country: "India",
                                           image1: ProfileImage(imageURL: URL(string: "https://drive.google.com/file/d/1vAKXuzS0uO-CI_fnCdl9cPOzbGHEicew/view"),
                                                                firebaseImagePath: "dummy_image"),
                                           image2: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                           image3: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                           image4: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                           image5: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                           image6: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                           doYouWorkOut: "Yes", // * show this later
                                           doYouDrink: "No", // * show this later
                                           doYouSmoke: "", // * show this later
                                           doYouWantBabies: "No") // * show this later
        return GeometryReader { geometry in
             UserSnapDetails(geometry:geometry)
                .environmentObject(profileModel)
                .environmentObject(PhotoModel())
        }
    }
}



