//
//  ChildCardView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI

struct ChildCardView: View {
    
    @Binding var singleProfile: CardProfileWithPhotos
    @State var geometry: GeometryProxy
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {

            LazyVStack {

                VStack {

                    ZStack {
                        if let urlString = self.singleProfile.image1?.imageURL {
                            VStack {
                                CardImages(profileImage: $singleProfile.image1, photoStruct: $singleProfile.photo1.boundPhoto, imageWidth: geometry.size.width, imageHeight: geometry.size.height)
//                                CardImages(imageURL: Binding.constant(urlString),
//                                       imageWidth: geometry.size.width,
//                                       imageHeight: geometry.size.height)
                            }

                            VStack {
                                Spacer()

                                NameAgeDistance(firstName: self.singleProfile.firstName.bound,
                                                lastName: self.singleProfile.lastName.bound,
                                                age: self.singleProfile.age.boundInt,
                                                profileDistanceFromUser: self.singleProfile.profileDistanceFromUser.boundInt,
                                                heightOfRectangle: geometry.size.height/9)
                            }

                        }
                        else {
                            NoPhotoProvided(imageWidth: geometry.size.width,
                                            imageHeight: geometry.size.height/1.5)
                        }
                    }

                    // Profile Names and age
                    // Profile Bio
                    ProfileBio(description: self.singleProfile.description.bound,
                               boxHeight:geometry.size.height/8)

                    // Profile Height, Education, Job, Religion, Location
                    CardBasicInfo(height: self.singleProfile.height.boundDouble,
                                  work: self.singleProfile.jobTitle.bound,
                                  education: self.singleProfile.education.bound,
                                  religion: self.singleProfile.religion.bound,
                                  politics: self.singleProfile.politics.bound,
                                  location: self.singleProfile.location.bound)
                        .padding(.horizontal,15)
                        .padding(.bottom,15)


                    if let urlString = self.singleProfile.image2?.imageURL {
                        VStack {
                            CardImages(profileImage: $singleProfile.image2, photoStruct: $singleProfile.photo2.boundPhoto, imageWidth: geometry.size.width, imageHeight: geometry.size.height)
//                           CardImages(imageURL: Binding.constant(urlString),
//                                   imageWidth: geometry.size.width,
//                                   imageHeight: geometry.size.height)
                        }
                    }


                    // Profile Passions
                    CardPassions(passions: self.singleProfile.interests.boundStringArray)
                        .padding(15)

                    if let urlString = self.singleProfile.image3?.imageURL {
                        VStack {
                            CardImages(profileImage: $singleProfile.image3, photoStruct: $singleProfile.photo3.boundPhoto, imageWidth: geometry.size.width, imageHeight: geometry.size.height)
//                            CardImages(imageURL: Binding.constant(urlString),
//                                   imageWidth: geometry.size.width,
//                                   imageHeight: geometry.size.height)
                        }
                    } else {
                        NoPhotoProvided(imageWidth: geometry.size.width,
                                        imageHeight: geometry.size.height/1.5)
                    }

                    if let urlString = self.singleProfile.image4?.imageURL {
                        VStack {
                            CardImages(profileImage: $singleProfile.image4, photoStruct: $singleProfile.photo4.boundPhoto, imageWidth: geometry.size.width, imageHeight: geometry.size.height)
//                            CardImages(imageURL: Binding.constant(urlString),
//                                   imageWidth: geometry.size.width,
//                                   imageHeight: geometry.size.height)
                        }
                    } else {
                        NoPhotoProvided(imageWidth: geometry.size.width,
                                        imageHeight: geometry.size.height/1.5)
                    }

                    if let urlString = self.singleProfile.image5?.imageURL {
                        VStack {
                            CardImages(profileImage: $singleProfile.image5, photoStruct: $singleProfile.photo5.boundPhoto, imageWidth: geometry.size.width, imageHeight: geometry.size.height)
//                            CardImages(imageURL:Binding.constant(urlString),
//                                   imageWidth: geometry.size.width,
//                                   imageHeight: geometry.size.height)
                        }
                    } else {
                        NoPhotoProvided(imageWidth: geometry.size.width,
                                        imageHeight: geometry.size.height/1.5)
                    }

                    if let urlString = self.singleProfile.image6?.imageURL {
                        VStack {
                            CardImages(profileImage: $singleProfile.image6, photoStruct: $singleProfile.photo6.boundPhoto, imageWidth: geometry.size.width, imageHeight: geometry.size.height)
//                            CardImages(imageURL: Binding.constant(urlString),
//                                   imageWidth: geometry.size.width,
//                                   imageHeight: geometry.size.height)
                        }
                    } else {
                        NoPhotoProvided(imageWidth: geometry.size.width,
                                        imageHeight: geometry.size.height/1.5)
                    }

                    // Report the profile
                    HStack {
                        Spacer()
                        Button {
                            // TODO - Report a Person
                        } label : {
                            Text("Report \(self.singleProfile.firstName.bound)")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding([.top,.bottom],30)
                }
            }
            .padding(.horizontal,10)
            .background(Color.white)

        }
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 0.1))
        
    }
}
