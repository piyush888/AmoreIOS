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
    @Environment(\.colorScheme) var colorScheme
    
    // About You Variables
    @Binding var careerField: String?
    @Binding var religion: String?
    @Binding var politics: String?
    @Binding var education: String?
    @Binding var countryRaisedIn: String?
    @Binding var doYouSmoke: String?
    @Binding var doYouDrink: String?
    @Binding var doYouWorkOut: String?
    @Binding var doYouWantBabies: String?
    @Binding var food: String?
    @Binding var passions: [String]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {

                LazyVStack{
                        // Image 1
                        // Profile Name, distance and age
//                    VStack(spacing:10) {
//                            
//                        }
                        
                    ZStack {
                        if profileModel.editUserProfile.image1?.imageURL != nil  {
                            ProfileImageView(profileImage: $profileModel.editUserProfile.image1,
                                             photo: $photoModel.photo1,
                                             width: geometry.size.width,
                                             height: .infinity)
                                
                            
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
                               headlineText:"Headline")
                        .padding(5)
                        
                        // Height, Education, Raised In, Religion, Political, Industry,
                        // Image 2
                        VStack {
                            
                            CardBasicInfo(height: profileModel.editUserProfile.height.boundDouble,
                                          education: self.education.bound,
                                          countryRaisedIn: self.countryRaisedIn.bound,
                                          religion: self.religion.bound,
                                          industry: self.careerField.bound,
                                          politics: self.politics.bound,
                                          food: self.food.bound)
                                .padding(.horizontal,15)
                                

                            if profileModel.editUserProfile.image2?.imageURL != nil  {
                                ProfileImageView(profileImage: $profileModel.editUserProfile.image2,
                                                     photo: $photoModel.photo2,
                                                     width: geometry.size.width,
                                                     height: .infinity)
                                        .padding(.vertical,5)
                                
                            }
                        }
                        
                        
                        // ProfileBioHeadline
                        // Work & School
                        // Image 3
                        VStack(spacing:5) {
                            ProfileBioHeadline(description: profileModel.editUserProfile.description.bound,
                                       headlineText:"Bio")
                            
                            // Show User Work and School At
                            WorkAndSchool(jobTitle:profileModel.editUserProfile.jobTitle.bound,
                                         work: profileModel.editUserProfile.work.bound,
                                          education:self.education.bound,
                                          school:profileModel.editUserProfile.school.bound
                            )
                            
                            
                            if profileModel.editUserProfile.image3?.imageURL != nil {
                                VStack {
                                    ProfileImageView(profileImage: $profileModel.editUserProfile.image3,
                                                     photo: $photoModel.photo3,
                                                     width: geometry.size.width,
                                                     height: .infinity)
                                        .cornerRadius(20)
                                        .padding(.vertical,5)
                                }
                            }
                        }
                        
                        
                        // CardPassions
                        // Image 4
                        VStack(spacing:5) {
                            // Profile Passions
                            CardPassions(passions: self.passions)
                                .padding(15)

                            if profileModel.editUserProfile.image4?.imageURL != nil {
                                VStack {
                                    ProfileImageView(profileImage: $profileModel.editUserProfile.image4,
                                                     photo: $photoModel.photo4,
                                                     width: geometry.size.width,
                                                     height: .infinity)
                                        .padding(.vertical,5)
                                }
                            }
                        }
                        
                        
                        // Card User Information like child_care, smooking_
                        VStack(spacing:5) {
                            UserOtherInformation(iconNameUserDataList:[FontIcon.text(.materialIcon(code: .child_care)),
                                                                       FontIcon.text(.materialIcon(code: .smoking_rooms)),
                                                                       FontIcon.text(.materialIcon(code: .fitness_center)),
                                                                       FontIcon.text(.materialIcon(code: .local_bar)),
                                                                       ],
                                                 userInfoFieldData:[self.doYouWantBabies.bound,
                                                                    self.doYouSmoke.bound,
                                                                    self.doYouWorkOut.bound,
                                                                    self.doYouDrink.bound
                                                                    ]
                                                )
                        
                           
                            if profileModel.editUserProfile.image5?.imageURL != nil  {
                                VStack {
                                    ProfileImageView(profileImage: $profileModel.editUserProfile.image5,
                                                     photo: $photoModel.photo5,
                                                     width: geometry.size.width,
                                                     height: .infinity)
                                        .padding(5)
                                }
                            }
                        
                            if profileModel.editUserProfile.image6?.imageURL != nil  {
                                VStack {
                                    ProfileImageView(profileImage: $profileModel.editUserProfile.image6,
                                                     photo: $photoModel.photo6,
                                                     width: geometry.size.width,
                                                     height: .infinity)
                                        .padding(5)
                                }
                            }
                            
                            
                            // Blank VStack to allow space of Superlikes dislikes buttons
                            // If you remove this VStack the buttons will overlap on profile content
                            VStack {
                                Text("")
                            }
                            .frame(height: 60)
                            .background(colorScheme == .dark ? Color(hex: 0x24244A): Color(hex: 0xe8f4f8))
                            .cornerRadius(15)
                            .blur(radius: 30)
                        
                        }
                        .padding([.bottom],40)

                }
                .background(colorScheme == .dark ? Color.black: Color.white)
                .foregroundColor(colorScheme == .dark ? Color.white: Color.black)
            }
            .cornerRadius(10)
            .padding(.horizontal,10)
            
        }
    }
}

struct PreviewProfile_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            previewCall
                .previewDisplayName("iPhone 13 Pro Max")
                .previewDevice("iPhone 13 Pro Max")
                
//            PreviewProfile()
//                .previewDisplayName("iPhone 13 Mini")
//                .previewDevice("iPhone 13 Mini")
//                .environmentObject(PhotoModel())
//                .environmentObject(ProfileViewModel())
//            PreviewProfile()
//                .previewDisplayName("iPhone 12 Pro")
//                .previewDevice("iPhone 12 Pro")
//                .environmentObject(PhotoModel())
//                .environmentObject(ProfileViewModel())
//            PreviewProfile()
//                .previewDisplayName("iPhone 11")
//                .previewDevice("iPhone 11")
//                .environmentObject(PhotoModel())
//                .environmentObject(ProfileViewModel())
        }
    }
    
    static var previewCall : some View {
        PreviewProfile(careerField:Binding.constant("Technology"),
                       religion:Binding.constant(""),
                       politics:Binding.constant(""),
                       education:Binding.constant(""),
                       countryRaisedIn:Binding.constant(""),
                       doYouSmoke:Binding.constant(""),
                       doYouDrink:Binding.constant(""),
                       doYouWorkOut:Binding.constant(""),
                       doYouWantBabies:Binding.constant(""),
                       food:Binding.constant(""),
                       passions:Binding.constant([""]))
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
    }
}
