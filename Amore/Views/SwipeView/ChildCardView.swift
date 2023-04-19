//
//  ChildCardView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI
import SwiftUIFontIcon
import CoreLocation

// Changes made in Child Card View have to be also reflected in the Preview
struct ChildCardView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    // Binding so that change in Profile while loading photos is reflected in View
    @State var singleProfile: CardProfileWithPhotos
    @Binding var swipeStatus: AllCardsView.LikeDislike
    @Binding var cardColor: Color
    
    @EnvironmentObject var profileModel: ProfileViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {

                LazyVStack {
                    VStack {

                        ZStack {
                            if self.singleProfile.image1?.imageURL != nil  {
                                CardImages(profileImage: singleProfile.image1,
                                           width:geometry.size.width,
                                           height: .infinity)
                                    
                                
                                VStack {
                                    Spacer()
                                    NameAgeDistance(firstName: self.singleProfile.firstName.bound,
                                                    lastName: self.singleProfile.lastName.bound,
                                                    age: self.singleProfile.age.boundInt,
                                                    profileDistanceFromUser: self.singleProfile.profileDistanceFromUser.boundDouble,
                                                    geometry: geometry)
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

                        ProfileBioHeadline(description: singleProfile.headline.bound,
                                   headlineText:"Headline",
                                   swipeStatus:$swipeStatus)
                            .padding(.leading,5)
                            .padding(.trailing,5)
                        
                        // Profile Height, Education, Job, Religion, Location
                        // Image 2
                        VStack(spacing:5) {
                            
                            CardBasicInfo(height: self.singleProfile.height.boundDouble,
                                          education: self.singleProfile.education.bound,
                                          countryRaisedIn: self.singleProfile.countryRaisedIn.bound,
                                          religion: self.singleProfile.religion.bound,
                                          industry: self.singleProfile.careerField.bound,
                                          politics: self.singleProfile.politics.bound,
                                          food: self.singleProfile.food.bound)
                                .padding(.horizontal,15)
                                .padding(.top,10)


                            if self.singleProfile.image2?.imageURL != nil  {
                                VStack {
                                    CardImages(profileImage: singleProfile.image2,
                                               width:geometry.size.width,
                                               height:.infinity)
                                        .padding(.vertical,5)
                                }
                            }
                        }
                        
                        
                        // Profile Bio
                        // Image 3
                        VStack(spacing:5) {
                            ProfileBioHeadline(description: self.singleProfile.description.bound,
                                               headlineText:"Bio",
                                               swipeStatus:$swipeStatus)
                                                .padding(5)
                            
                            // Show User Work and School At
                            WorkAndSchool(jobTitle:self.singleProfile.jobTitle.bound,
                                         work: self.singleProfile.work.bound,
                                          education:self.singleProfile.education.bound,
                                          school:self.singleProfile.school.bound)
                                
                            
                            if self.singleProfile.image3?.imageURL != nil {
                                VStack {
                                    CardImages(profileImage: singleProfile.image3,
                                               width:geometry.size.width,
                                               height:.infinity)
                                        .padding(.vertical,5)
                                }
                            }
                        }
                        
                        
                        // Profile Passions
                        // Image 4
                        VStack(spacing:5) {
                            // Profile Passions
                            CardPassions(passions: self.singleProfile.interests.boundStringArray)
                                .padding(15)

                            if self.singleProfile.image4?.imageURL != nil {
                                VStack {
                                    CardImages(profileImage: singleProfile.image4,
                                               width:geometry.size.width,
                                               height:.infinity)
                                        .padding(.vertical,2.5)
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
                                                 userInfoFieldData:[self.singleProfile.doYouWantBabies.bound,
                                                                    self.singleProfile.doYouSmoke.bound,
                                                                    self.singleProfile.doYouWorkOut.bound,
                                                                    self.singleProfile.doYouDrink.bound
                                                                    ]
                                                )
                                .padding(.vertical,2.5)
                            
                            if self.singleProfile.image5?.imageURL != nil  {
                                VStack {
                                    CardImages(profileImage: singleProfile.image5,
                                               width:geometry.size.width,
                                               height:.infinity)
                                        .padding(.top,2.5)
                                        .padding(.bottom,5)
                                }
                            }
                        }
                        
                        if self.singleProfile.image6?.imageURL != nil  {
                            VStack {
                                CardImages(profileImage: singleProfile.image6,
                                           width:geometry.size.width,
                                           height:.infinity)
                                    .padding(.vertical,5)
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
                }
                .background(swipeStatus == .none ? colorScheme == .dark ? Color.black: Color.white : cardColor)
                .foregroundColor(swipeStatus == .none ? colorScheme == .dark ? Color.white: Color.black: Color.white)
            }
            .cornerRadius(10)
            .padding(.horizontal,10)
            
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
                                                image1: ProfileImage(imageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/amore-f8cd6.appspot.com/o/images%2FQvV4OoZmZ3QWHhMNaZrr7lkqmLF3%2Fimage1637162606.404443.heic?alt=media&token=b91a59f4-1b39-4b28-b972-9d4d5252fd76"),
                                                                     firebaseImagePath: "images/QvV4OoZmZ3QWHhMNaZrr7lkqmLF3/image1637162606.404443.heic"),
                                                image2: ProfileImage(imageURL: URL(string: "SampleImage2"),firebaseImagePath: "SampleImage2"),
                                                image3: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                                image4: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                                image5: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                                image6: ProfileImage(imageURL: URL(string: "x"),firebaseImagePath: "x"),
                                                doYouWorkOut: "Yes", // * show this later
                                                doYouDrink: "No", // * show this later
                                                doYouSmoke: "", // * show this later
                                                doYouWantBabies: "No" // * show this later
        )
        
        ChildCardView(singleProfile:tempProfile,
                      swipeStatus: Binding.constant(AllCardsView.LikeDislike.dislike),
                      cardColor: Binding.constant(Color.green))
            .environmentObject(ProfileViewModel())
        
    }
}
