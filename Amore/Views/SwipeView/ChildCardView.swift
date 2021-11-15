//
//  ChildCardView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI

struct ChildCardView: View {
    
    @State var imageName1: String
    @State var imageName2: String
    @State var imageName3: String
    @State var imageName4: String
    @State var imageName5: String
    @State var imageName6: String
    @State var firstName: String
    @State var lastName: String
    @State var profileDistanceFromUser: Int
    @State var description: String
    @State var height: String
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
                        CardImages(imageName:imageName1,
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
                        
                    
                    CardImages(imageName:imageName2,
                               imageWidth:geometry.size.width,
                               imageHeight:geometry.size.height)
                    
                    
                    // Profile Passions
                    CardPassions(passions: passions)
                        .padding(15)
                
                    
                    CardImages(imageName:imageName3,
                               imageWidth:geometry.size.width,
                               imageHeight:geometry.size.height)
                    
                    
                    CardImages(imageName:imageName4,
                               imageWidth:geometry.size.width,
                               imageHeight:geometry.size.height)
                        .padding(.top,15)
                    
                    
                    CardImages(imageName:imageName5,
                               imageWidth:geometry.size.width,
                               imageHeight:geometry.size.height)
                        .padding(.top,15)
                    
                    
                    CardImages(imageName:imageName6,
                               imageWidth:geometry.size.width,
                               imageHeight:geometry.size.height)
                        .padding(.top,15)
                    
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


