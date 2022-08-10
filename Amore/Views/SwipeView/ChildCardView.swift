//
//  ChildCardView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI
import SwiftUIFontIcon
import CoreLocation

// Changes made in Child Card View have to be also reflected in the Preview Profile
struct ChildCardView: View {
    
    @Binding var singleProfile: CardProfileWithPhotos
    @EnvironmentObject var profileModel: ProfileViewModel
    @State var testing: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {

                LazyVStack {
                    VStack {
                        
                        // Image 1
                        // Profile Name, distance and age
                        Group {
                            ZStack {
                                if self.singleProfile.image1?.imageURL != nil  {
                                    CardImages(profileImage: $singleProfile.image1,
                                               photoStruct: $singleProfile.photo1.boundPhoto,
                                               width:geometry.size.width-10,
                                               height:geometry.size.height/2,
                                               testing:testing)
                                        .cornerRadius(20)
                                        .padding(5)
                                    
                                    VStack {
                                        Spacer()
                                        NameAgeDistance(firstName: self.singleProfile.firstName.bound,
                                                        lastName: self.singleProfile.lastName.bound,
                                                        age: self.singleProfile.age.boundInt,
                                                        profileDistanceFromUser: self.$singleProfile.profileDistanceFromUser.boundDouble,
                                                        geometry: geometry,
                                                        isPreviewProfile:true)
                                            .onAppear {
                                                if singleProfile.location != nil {
                                                    let profileLocation = CLLocation(latitude: singleProfile.location!.latitude.boundDouble,
                                                                                     longitude: singleProfile.location!.longitude.boundDouble)
                                                    // Calculates distance between user and profile
                                                    if profileModel.lastSeenLocation != nil {
                                                        self.singleProfile.profileDistanceFromUser = profileModel.lastSeenLocation!.distance(from: profileLocation) / 1000
                                                    }
                                                }
                                                
                                            }
                                    }
                                }
                            }
                            
                            ProfileBioHeadline(description: self.singleProfile.headline.bound,
                                               headlineText:"Headline")
                                .padding(5)
                    
                        }

                        
                        // Profile Height, Education, Job, Religion, Location
                        // Image 2
                        Group {
                            CardBasicInfo(height: self.singleProfile.height.boundDouble,
                                          work: self.singleProfile.jobTitle.bound,
                                          education: self.singleProfile.education.bound,
                                          religion: self.singleProfile.religion.bound,
                                          profileCompletion:self.singleProfile.profileCompletion.boundDouble,
                                          countryRaisedIn: self.singleProfile.countryRaisedIn.bound)
                                .padding(.horizontal,15)
                                .padding(.top,10)


                            if self.singleProfile.image2?.imageURL != nil  {
                                VStack {
                                    CardImages(profileImage: $singleProfile.image2,
                                               photoStruct: $singleProfile.photo2.boundPhoto,
                                               width:geometry.size.width-10,
                                               height:geometry.size.height/2,
                                               testing:testing)
                                        .cornerRadius(20)
                                        .padding(5)
                                }
                            }
                        }
                        
                        
                        // Profile Passion
                        // Image 3
                        Group {
                            ProfileBioHeadline(description: self.singleProfile.description.bound,
                                               headlineText:"Bio")
                                                .padding(5)

                            if self.singleProfile.image3?.imageURL != nil {
                                VStack {
                                    CardImages(profileImage: $singleProfile.image3,
                                               photoStruct: $singleProfile.photo3.boundPhoto,
                                               width:geometry.size.width-10,
                                               height:geometry.size.height/2,
                                               testing:testing)
                                        .cornerRadius(20)
                                        .padding(5)
                                }
                            }
                        }
                        
                        
                        // Work and School
                        // Image 4
                        Group {
                            // Profile Passions
                            CardPassions(passions: self.singleProfile.interests.boundStringArray)
                                .padding(15)


                            // Show User Work and School At
                            WorkAndSchool(jobTitle:self.singleProfile.jobTitle.bound,
                                         work: self.singleProfile.work.bound,
                                          education:self.singleProfile.education.bound,
                                          school:self.singleProfile.school.bound)
                                
                            
                            
                            if self.singleProfile.image4?.imageURL != nil {
                                VStack {
                                    CardImages(profileImage: $singleProfile.image4,
                                               photoStruct: $singleProfile.photo4.boundPhoto,
                                               width:geometry.size.width-10,
                                               height:geometry.size.height/2,
                                               testing:testing)
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
                                                 userInfoFieldData:[self.singleProfile.doYouWantBabies.bound,
                                                                    self.singleProfile.doYouSmoke.bound,
                                                                    self.singleProfile.doYouWorkOut.bound,
                                                                    self.singleProfile.education.bound,
                                                                    self.singleProfile.doYouDrink.bound
                                                                    ]
                                                )
                        
                            if self.singleProfile.image5?.imageURL != nil  {
                                VStack {
                                    CardImages(profileImage: $singleProfile.image5,
                                               photoStruct: $singleProfile.photo5.boundPhoto,
                                               width:geometry.size.width-10,
                                               height:geometry.size.height/2,
                                               testing:testing)
                                        .cornerRadius(20)
                                        .padding(5)
                                }
                            }
                        }
                        
                        if self.singleProfile.image6?.imageURL != nil  {
                            VStack {
                                CardImages(profileImage: $singleProfile.image6,
                                           photoStruct: $singleProfile.photo6.boundPhoto,
                                           width:geometry.size.width-10,
                                           height:geometry.size.height/2,
                                           testing:testing)
                                    .cornerRadius(20)
                                    .padding(5)
                            }
                            
                        }
                        
                        // Blank VStack to allow space of Superlikes dislikes buttons
                        // If you remove this VStack the buttons will overlap on profile content
                        VStack {
                            Text("")
                        }
                        .frame(height: 80)
                        .background(colorScheme == .dark ? Color(hex: 0x24244A): Color(hex: 0xe8f4f8))
                        .cornerRadius(15)
                        .blur(radius: 30)
                        
                    }
                }
//                .padding(.horizontal,10)
                .background(colorScheme == .dark ? Color.black: Color.white)
                .foregroundColor(colorScheme == .dark ? Color.white: Color.black)
            }
            .cornerRadius(10)
        }
        
    }
}


struct ChildCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        let tempProfile = CardProfileWithPhotos(id: "Test123456",  //can't be nil
                                                firstName: "Neha", //can't be nil
                                                lastName: "Sharma",  //can't be nil
                                                dateOfBirth: "October 14, 2021",  //can't be nil
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
                                                image1: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                                image2: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                                image3: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                                image4: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                                image5: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                                image6: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                                doYouWorkOut: "Yes", // * show this later
                                                doYouDrink: "No", // * show this later
                                                doYouSmoke: "", // * show this later
                                                doYouWantBabies: "No" // * show this later
        )
        
        ChildCardView(singleProfile: Binding.constant(tempProfile), testing: true)
            .environmentObject(ProfileViewModel())
        
    }
}
