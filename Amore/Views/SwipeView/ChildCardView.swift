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
                        if self.singleProfile.image1?.imageURL != nil  {
                            VStack {
                                CardImages(profileImage: $singleProfile.image1, photoStruct: $singleProfile.photo1.boundPhoto, imageWidth: geometry.size.width, imageHeight: geometry.size.height)
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


                    if self.singleProfile.image2?.imageURL != nil  {
                        VStack {
                            CardImages(profileImage: $singleProfile.image2, photoStruct: $singleProfile.photo2.boundPhoto, imageWidth: geometry.size.width, imageHeight: geometry.size.height)
                        }
                    }

                    // Profile Passions
                    CardPassions(passions: self.singleProfile.interests.boundStringArray)
                        .padding(15)

                    if self.singleProfile.image3?.imageURL != nil {
                        VStack {
                            CardImages(profileImage: $singleProfile.image3, photoStruct: $singleProfile.photo3.boundPhoto, imageWidth: geometry.size.width, imageHeight: geometry.size.height)
                        }
                    }

                    if self.singleProfile.image4?.imageURL != nil {
                        VStack {
                            CardImages(profileImage: $singleProfile.image4, photoStruct: $singleProfile.photo4.boundPhoto, imageWidth: geometry.size.width, imageHeight: geometry.size.height)
                        }
                    }
                    
                    if self.singleProfile.image5?.imageURL != nil  {
                        VStack {
                            CardImages(profileImage: $singleProfile.image5, photoStruct: $singleProfile.photo5.boundPhoto, imageWidth: geometry.size.width, imageHeight: geometry.size.height)
                        }
                    }
                    
                    if self.singleProfile.image6?.imageURL != nil  {
                        VStack {
                            CardImages(profileImage: $singleProfile.image6, photoStruct: $singleProfile.photo6.boundPhoto, imageWidth: geometry.size.width, imageHeight: geometry.size.height)
                        }
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


struct ChildCardView_Previews: PreviewProvider {
    static var previews: some View {
        let tempProfile = CardProfileWithPhotos(id: "Test123456",
                              firstName: "Neha",
                              lastName: "Sharma",
                              dateOfBirth: "October 14, 2021",
                              interests: ["Running","Gaming","Helping"],
                              sexualOrientation: ["Straight"],
                              sexualOrientationVisible: true,
                              showMePreference: "Women",
                              work: "Bank of America",
                              school: "Harvard University",
                              age: 25,
                              headline: "Hey Pumpkin",
                              profileDistanceFromUser: 0,
                              jobTitle: "VP",
                              workType: "Remove this field",
                              height: 5.6,
                              education: "Masters in Science",
                              religion: "Hindu",
                              community: "Brahmin",
                              politics: "Liberal",
                              location: "Coordinates",
                              description: "this field is description",
                              country: "India",
                              image1: ProfileImage(imageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/amore-f8cd6.appspot.com/o/images%2FQvV4OoZmZ3QWHhMNaZrr7lkqmLF3%2Fimage1637162606.404443.heic?alt=media&token=b91a59f4-1b39-4b28-b972-9d4d5252fd76"),
                                                   firebaseImagePath: "images/QvV4OoZmZ3QWHhMNaZrr7lkqmLF3/image1637162606.404443.heic"),
                              image2: ProfileImage(imageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/amore-f8cd6.appspot.com/o/images%2FQvV4OoZmZ3QWHhMNaZrr7lkqmLF3%2Fimage1637162885.375509.heic?alt=media&token=632dde36-746c-4dc4-8e83-5b19e85f6d82"),
                                                   firebaseImagePath: "images/QvV4OoZmZ3QWHhMNaZrr7lkqmLF3/image1637162885.375509.heic"),
                              image3: ProfileImage(imageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/amore-f8cd6.appspot.com/o/images%2FQvV4OoZmZ3QWHhMNaZrr7lkqmLF3%2Fimage1637233645.380225.heic?alt=media&token=5280b317-0f00-4544-9a78-70ebc1e8ee7a"), firebaseImagePath: "images/QvV4OoZmZ3QWHhMNaZrr7lkqmLF3/image1637233645.380225.heic"),
                              doYouWorkOut: "Yes",
                              doYouDrink: "No",
                              doYouSmoke: "Yes",
                              doYouWantBabies: "No")
        
        GeometryReader { geometry in
            ChildCardView(singleProfile: Binding.constant(tempProfile), geometry: geometry)
        }
    }
}
