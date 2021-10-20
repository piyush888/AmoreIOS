//
//  SingleCardView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/9/21.
//

import SwiftUI

struct SingleCardView: View {
    @State private var translation: CGSize = .zero
    @State private var swipeStatus: LikeDislike = .none
    
    public var user: User
    private var onRemove: (_ user: User) -> Void
    
    private var thresholdPercentage: CGFloat = 0.25 // when the user has draged 50% the width of the screen in either direction
    
    private enum LikeDislike: Int {
        case like, dislike, none
    }
    
    init(user: User, onRemove: @escaping (_ user: User) -> Void) {
        self.user = user
        self.onRemove = onRemove
    }
    
    /// What percentage of our own width have we swipped
    /// - Parameters:
    ///   - geometry: The geometry
    ///   - gesture: The current gesture translation value
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    
                    // User Start Image
                     ZStack(alignment: self.swipeStatus == .like ? .topLeading : .topTrailing) {
                        
                         Image(self.user.imageName1)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            //.frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                            .clipped()
                        
                        if self.swipeStatus == .like {
                            Text("LIKE")
                                .font(.title)
                                .padding()
                                .cornerRadius(10)
                                .foregroundColor(Color.green)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.green, lineWidth: 3.0)
                            ).padding(24)
                                .rotationEffect(Angle.degrees(-45))
                        } else if self.swipeStatus == .dislike {
                            Text("DISLIKE")
                                .font(.title)
                                .padding()
                                .cornerRadius(10)
                                .foregroundColor(Color.red)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red, lineWidth: 3.0)
                            ).padding(.top, 45)
                                .rotationEffect(Angle.degrees(45))
                        }
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
                        
                        
                        // Report the profile
                        HStack {
                            Spacer()
                            Button {
                                // TODO - Report a Person
                            } label : {
                                Text("Report \(self.user.firstName)")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding([.top,.bottom],30)
                    }
                    .padding(.horizontal,10)
                }
                .background(Color.white)
                .animation(.interactiveSpring())
                .offset(x: self.translation.width, y: 0)
                .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.translation = value.translation
                            
                            if (self.getGesturePercentage(geometry, from: value)) >= self.thresholdPercentage {
                                self.swipeStatus = .like
                            } else if self.getGesturePercentage(geometry, from: value) <= -self.thresholdPercentage {
                                self.swipeStatus = .dislike
                            } else {
                                self.swipeStatus = .none
                            }
                            
                    }.onEnded { value in
                        // determine snap distance > 0.5 aka half the width of the screen
                            if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                                self.onRemove(self.user)
                            } else {
                                self.translation = .zero
                            }
                        }
                )
            }
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 0.1))
        }
    }
}

// 7
struct SingleCardView_Previews: PreviewProvider {
    static var previews: some View {
        SingleCardView(user: User(id: 0, firstName: "Cindy", lastName: "Jones", age: 23, profileDistanceFromUser: 4,imageName1: "image1",imageName2: "image2",imageName3: "image3",imageName4: "image4",imageName5: "image5",imageName6: "image6", occupation: "Coach", passions: ["Photography", "Shopping", "Yoga","Cooking","Travelling","Drink","Gaming","Partying"],
                            height: "5 55", education:"Bachelor",religion:"Hindu", politics:"Liberal", location:"Texas, US",
                            description:"You are strong because you are imperfect, you have doubts because you are wise"),
                 onRemove: { _ in
                    // do nothing
            })
    }
}
