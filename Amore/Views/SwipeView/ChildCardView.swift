//
//  ChildCardView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI

struct ChildCardView: View {
    
    @State var imageURL1: URL?
    @State var imageURL2: URL?
    @State var imageURL3: URL?
    @State var imageURL4: URL?
    @State var imageURL5: URL?
    @State var imageURL6: URL?
    @State var firstName: String
    @State var lastName: String
    @State var profileDistanceFromUser: Int
    @State var description: String
    @State var height: Double
    @State var occupation: String
    @State var education: String
    @State var religion: String
    @State var politics: String
    @State var location: String
    @State var passions: [String] = [""]
    @State var geometry: GeometryProxy
    
    @State var age: Int
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            LazyVStack {
             
                VStack {
                    
                    ZStack {
                        if let urlString = imageURL1 {
                            CardImages(imageURL:urlString,
                                   imageWidth:geometry.size.width,
                                   imageHeight:geometry.size.height)
                            
                            VStack {
                                Spacer()
                                
                                NameAgeDistance(firstName: firstName,
                                                lastName: lastName,
                                                age: age,
                                                profileDistanceFromUser: profileDistanceFromUser,
                                                heightOfRectangle: geometry.size.height/9)
                            }
                            
                        } else {
                            NoPhotoProvided(imageWidth:geometry.size.width,
                                            imageHeight:geometry.size.height/1.5)
                        }
                    }
                    
                    // Profile Names and age
                    // Profile Bio
                    ProfileBio(description: description,
                               boxHeight:geometry.size.height/8)
                    
                    // Profile Height, Education, Job, Religion, Location
                    CardBasicInfo(height: height,
                                   work: occupation,
                                   education: education,
                                   religion: religion,
                                   politics: politics,
                                   location: location)
                        .padding(.horizontal,15)
                        .padding(.bottom,15)
                        
                    
                    if let urlString = imageURL2 {
                        CardImages(imageURL:urlString,
                               imageWidth:geometry.size.width,
                               imageHeight:geometry.size.height)
                    }
                    
                    
                    // Profile Passions
                    CardPassions(passions: passions)
                        .padding(15)
                
                    if let urlString = imageURL3 {
                        CardImages(imageURL:urlString,
                               imageWidth:geometry.size.width,
                               imageHeight:geometry.size.height)
                    } else {
                        NoPhotoProvided(imageWidth:geometry.size.width,
                                        imageHeight:geometry.size.height/1.5)
                    }
                    
                    if let urlString = imageURL4 {
                        CardImages(imageURL:urlString,
                               imageWidth:geometry.size.width,
                               imageHeight:geometry.size.height)
                    } else {
                        NoPhotoProvided(imageWidth:geometry.size.width,
                                        imageHeight:geometry.size.height/1.5)
                    }
                    
                    if let urlString = imageURL5 {
                        CardImages(imageURL:urlString,
                               imageWidth:geometry.size.width,
                               imageHeight:geometry.size.height)
                    } else {
                        NoPhotoProvided(imageWidth:geometry.size.width,
                                        imageHeight:geometry.size.height/1.5)
                    }
                    
                    if let urlString = imageURL6 {
                        CardImages(imageURL:urlString,
                               imageWidth:geometry.size.width,
                               imageHeight:geometry.size.height)
                    } else {
                        NoPhotoProvided(imageWidth:geometry.size.width,
                                        imageHeight:geometry.size.height/1.5)
                    }
                    
                    // Report the profile
                    HStack {
                        Spacer()
                        Button {
                            // TODO - Report a Person
                        } label : {
                            Text("Report \(firstName)")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding([.top,.bottom],30)
                }
                .padding(.horizontal,10)
            }
            .background(Color.white)
            
        }
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 0.1))
        
        
        
    }
}


