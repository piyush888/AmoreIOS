//
//  PreviewProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/25/21.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftUIFontIcon

struct PreviewProfile: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {

                LazyVStack {

                    VStack {
                        
                        // Image 1
                        // Profile Name, distance and age
                        Group {
                            ZStack {
                                if profileModel.editUserProfile.image1?.imageURL != nil  {
                                    ProfileImageView(profileImage: $profileModel.editUserProfile.image1, photo: $photoModel.photo1, customModifier: PreviewProfileModifier(width: geometry.size.width-10, height: geometry.size.height/2))
                                        .cornerRadius(20)
                                        .padding(5)
                                    
                                    VStack {
                                        Spacer()
                                        NameAgeDistance(firstName: profileModel.editUserProfile.firstName.bound,
                                                        lastName: profileModel.editUserProfile.lastName.bound,
                                                        age: profileModel.editUserProfile.age.boundInt,
                                                        profileDistanceFromUser: $profileModel.editUserProfile.profileDistanceFromUser.boundDouble,
                                                        geometry: geometry)
                                    }
                                }
                            }
                            
                            ProfileBioHeadline(description: profileModel.editUserProfile.headline.bound,
                                       bgColor:Color(hex: 0xe8f4f8),
                                       headlineText:"Headline")
                    
                        }

                        
                        // Profile Height, Education, Job, Religion, Location
                        // Image 2
                        Group {
                            CardBasicInfo(height: profileModel.editUserProfile.height.boundDouble,
                                          work: profileModel.editUserProfile.jobTitle.bound,
                                          education: profileModel.editUserProfile.education.bound,
                                          religion: profileModel.editUserProfile.religion.bound,
                                          profileCompletion: profileModel.editUserProfile.profileCompletion.boundDouble,
                                          countryRaisedIn: profileModel.editUserProfile.countryRaisedIn.bound)
                                .padding(.horizontal,15)


                            if profileModel.editUserProfile.image2?.imageURL != nil  {
                                VStack {
                                    ProfileImageView(profileImage: $profileModel.editUserProfile.image2, photo: $photoModel.photo2, customModifier: PreviewProfileModifier(width: geometry.size.width-10, height: geometry.size.height/2))
                                        .cornerRadius(20)
                                        .padding(5)
                                }
                            }
                        }
                        
                        
                        // Profile Passion
                        // Image 3
                        Group {
                            ProfileBioHeadline(description: profileModel.editUserProfile.description.bound,
                                       bgColor:Color(hex: 0xFFFFE0),
                                       headlineText:"Bio")

                            if profileModel.editUserProfile.image3?.imageURL != nil {
                                VStack {
                                    ProfileImageView(profileImage: $profileModel.editUserProfile.image3, photo: $photoModel.photo3, customModifier: PreviewProfileModifier(width: geometry.size.width-10, height: geometry.size.height/2))
                                        .cornerRadius(20)
                                        .padding(5)
                                }
                            }
                        }
                        
                        
                        // Work and School
                        // Image 4
                        Group {
                            // Profile Passions
                            CardPassions(passions: profileModel.editUserProfile.interests.boundStringArray)
                                .padding(15)


                            // Show User Work and School At
                            WorkAndSchool(work: profileModel.editUserProfile.work.bound,
                                          jobTitle:profileModel.editUserProfile.jobTitle.bound,
                                          education:profileModel.editUserProfile.education.bound,
                                          school:profileModel.editUserProfile.school.bound
                            )
                            
                            
                            if profileModel.editUserProfile.image4?.imageURL != nil {
                                VStack {
                                    ProfileImageView(profileImage: $profileModel.editUserProfile.image4, photo: $photoModel.photo4, customModifier: PreviewProfileModifier(width: geometry.size.width-10, height: geometry.size.height/2))
                                        .cornerRadius(20)
                                        .padding(5)
                                }
                            }
                        }
                        
                        
                        // Card User Information like child_care, smooking_
                        Group {
                            UserOtherInformation(iconNameUserDataList:[FontIcon.text(.materialIcon(code: .child_care)),
                                                                       FontIcon.text(.materialIcon(code: .smoking_rooms)),
                                                                       FontIcon.text(.materialIcon(code: .fitness_center)),
                                                                       FontIcon.text(.materialIcon(code: .school)),
                                                                       FontIcon.text(.materialIcon(code: .local_bar)),
                                                                       ],
                                                 userInfoFieldData:[profileModel.editUserProfile.doYouWantBabies.bound,
                                                                    profileModel.editUserProfile.doYouSmoke.bound,
                                                                    profileModel.editUserProfile.doYouWorkOut.bound,
                                                                    profileModel.editUserProfile.education.bound,
                                                                    profileModel.editUserProfile.doYouDrink.bound
                                                                    ]
                                                )
                        
                            if profileModel.editUserProfile.image5?.imageURL != nil  {
                                VStack {
                                    ProfileImageView(profileImage: $profileModel.editUserProfile.image5, photo: $photoModel.photo5, customModifier: PreviewProfileModifier(width: geometry.size.width-10, height: geometry.size.height/2))
                                        .cornerRadius(20)
                                        .padding(5)
                                }
                            }
                            
                        }
                        
                        if profileModel.editUserProfile.image6?.imageURL != nil  {
                            VStack {
                                ProfileImageView(profileImage: $profileModel.editUserProfile.image6, photo: $photoModel.photo6, customModifier: PreviewProfileModifier(width: geometry.size.width-10, height: geometry.size.height/2))
                                    .cornerRadius(20)
                                    .padding(5)
                            }
                        }
                        
                        // Report the profile
//                        HStack {
//                            Spacer()
//                            Button {
//                                // TODO - Report a Person
//                            } label : {
//                                Text("Report \(profileModel.editUserProfile.firstName.bound)")
//                                    .foregroundColor(.gray)
//                            }
//                            Spacer()
//                        }
//                        .padding([.top,.bottom],30)
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
}

struct PreviewProfile_Previews: PreviewProvider {
    static var previews: some View {
        PreviewProfile()
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
    }
}
