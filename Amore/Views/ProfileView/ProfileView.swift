//
//  ProfileView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/5/21.
// User - Person who is logged on device
// Profie - The possible matches

import SwiftUI

struct ProfileView: View {
    
    var images = ["image1", "image2", "image3", "image4"]
    
    var profileName = "Jessica Parker"
    var profileAge = "23"
    var profileWorkAt = "Professional Model"
    
    var profileCity = "Chicago"
    var profileState = "IL"
    var profileCountry = "United States"
    var profileDistanceFromUser = "1"
    
    var passions = ["Photography", "Shopping", "Yoga","Cooking","Travelling",
                    "Drink","Gaming","Partying"]
    
    
    var profileBio = "You are strong because you are imperfect, you have doubts because you are wise"
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                PhotosViewCarousel(images: images)
                    .padding(.top,30)
                
                // VStack for all the profile details
                VStack {
                    
                    // Dislike, Like and Superlike
                    LikeDislikeSuperLike()
                    
                    // Profile Name, Work and send a message
                    HStack {
                        
                        VStack(alignment: .leading) {
                            Text("\(profileName), \(profileAge)")
                                .font(.BoardingTitle2)
                            
                            Text("\(profileWorkAt)")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        Button {
                            //TODO send message to the person when send meesage button is pressed
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.white)
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 1))
                                
                                Image(systemName: "paperplane")
                                    .resizable()
                                    .frame(width:25, height:25)
                                    .foregroundColor(.pink)
                                    .onTapGesture {
                                        //TODO
                                    }
                            }
                        }
                    }.padding(.top,10)
                    
                    // Location and Distance From Current User
                    HStack {
                        LocationInfoView(profileCity: profileCity,
                                         profileState: profileState,
                                         profileCountry: profileCountry,
                                         profileDistanceFromUser: profileDistanceFromUser)
                    }.padding(.top,10)
                    
                    // Profile Bio/About or Anthem
                    HStack {
                        AboutView(profileBio: profileBio)
                        Spacer()
                    }.padding(.top,10)
                    
                    // Profile Passions
                    HStack {
                        PassionsCombinedString(passions: passions)
                        Spacer()
                    }.padding(.top,10)
                    
                    HStack(alignment:.center) {
                        Button {
                            // TODO - Report a Person
                        } label : {
                            Text("Report \(profileName)")
                                .foregroundColor(.gray)
                        }
                    }.padding([.top,.bottom],30)
                    
                }
                .padding(.horizontal,20)
                
                
            }
        }
        .ignoresSafeArea(.all)
        
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
