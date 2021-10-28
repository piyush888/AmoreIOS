//
//  PreviewProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/25/21.
//

import SwiftUI

struct PreviewProfile: View {
    
    public var user: User
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    
                    VStack {
                        Image(self.user.imageName1)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        //.frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                            .clipped()
                    }
                    
                    VStack {
                        // Profile Names and age
                        // Profile Bio
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(self.user.firstName) \(self.user.lastName), \(self.user.age)")
                                    .font(.title2)
                                    .bold()
                                Text(self.user.description)
                                    .font(.subheadline)
                                
                                // User Location and distance
                                ZStack {
                                    HStack {
                                        Image(systemName: "mappin.and.ellipse")
                                            .resizable()
                                            .frame(width:20, height:20)
                                            .foregroundColor(.black)
                                        
                                        Text("\(self.user.profileDistanceFromUser) km away")
                                            .foregroundColor(.black)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            Spacer()
                        }
                        
                        
                        // Profile Height, Education, Job, Religion, Location
                        CardBasicInfo(height: self.user.height,
                                      work: self.user.occupation,
                                      education: self.user.education,
                                      religion: self.user.religion,
                                      politics: self.user.politics,
                                      location: self.user.location)
                            .padding(.top,10)
                        
                        
                        // Profile Passions
                        CardPassions(passions: self.user.passions)
                            .padding(.top,10)
                        
                        
                        // Gallery
                        CardGalleryImages(deviceWidth:(geometry.size.width - 25),
                                          user:self.user)
                            .padding(.top,10)
                    }
                    .padding(.horizontal,10)
                }
            }
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 0.1))
        }
    }
}

struct PreviewProfile_Previews: PreviewProvider {
    static var previews: some View {
        PreviewProfile(user: User(id: 0, firstName: "Cindy", lastName: "Jones", age: 23, profileDistanceFromUser: 4, imageName1: "girl1_image1",imageName2: "girl1_image2",imageName3: "girl1_image3",imageName4: "girl1_image4",imageName5: "girl1_image5",imageName6: "girl1_image6", occupation: "Coach", passions: ["Photography", "Shopping"], height: "5 55", education:"Bachelor",religion:"Hindu",politics:"Liberal", location:"Texas, US", description:"You are strong because you are imperfect, you have doubts because you are wise"))
    }
}
