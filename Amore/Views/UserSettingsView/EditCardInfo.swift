//
//  EditCardInfo.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/24/21.
//

import SwiftUI

struct EditCardInfo: View {
    
    @State var images = [UIImage?](repeating: nil, count: 6)
    
    @ObservedObject var headLine = TextBindingManager(limit: 20)
    @ObservedObject var aboutMe = TextBindingManager(limit: 260)
    @ObservedObject var jobTitle = TextBindingManager(limit: 20)
    @ObservedObject var addCompany = TextBindingManager(limit: 20)
    @ObservedObject var addSchool = TextBindingManager(limit: 20)
    
    
    // Basic Info
    @State var genderPreference = "Man"
    // Age perference - Scales are according to screen
    // 66.66(Scale on screen) / 368.0 (Max size of screen self.MaxPossibleAg) = 18
    // 215.66(Scale on screen) / 368.0 (Max size of screen self.MaxPossibleAg) = 61
    @State var scaleMinAge : CGFloat = 66.66
    @State var scaleMaxAge : CGFloat = 215.66
    @State var realMinAge : String = String(format : "%.0f",(66.66 / (UIScreen.main.bounds.width - 60) * 100))
    @State var realMaxAge : String = String(format : "%.0f",(215.66 / (UIScreen.main.bounds.width - 60) * 100))
    
    // Religious prefernce
    @State var religionPreference = ["Any"]
    @State var communityPreference = ["Any"]
    @State var careerPreference = ["Any"]
    @State var educationPreference = "Masters"
    @State var countryPreference = "India"
    
    //Discovery - Variable if user wants to hide the card from public view
    @State private var discoveryStatus = false
    
    //Notification - turn on notificatoins on user device
    @State private var notificationsStatus = false
    
    
    let adaptivecolumns = Array(repeating:
                                    GridItem(.adaptive(minimum: 150),spacing: 5,
                                             alignment: .center),count: 3)
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack {
                
                // Display Photos
                LazyVGrid(columns: adaptivecolumns, content: {
                    UploadPhotoWindow(image: self.$images[0])
                    UploadPhotoWindow(image: self.$images[1])
                    UploadPhotoWindow(image: self.$images[2])
                    UploadPhotoWindow(image: self.$images[3])
                    UploadPhotoWindow(image: self.$images[4])
                    UploadPhotoWindow(image: self.$images[5])
                })
                
                
                // Edit Headline
                EditCardForm(formHeight: 40.0,
                             formHeadLine: "Headline",
                             formInput: headLine)
                
                // Edit About Me
                EditCardForm(formHeight: 100.0,
                             formHeadLine: "About Me",
                             formInput: aboutMe)
                
                // Job title
                EditCardForm(formHeight: 40.0,
                             formHeadLine: "Job Title",
                             formInput: jobTitle)
                
                
                // Add Company
                EditCardForm(formHeight: 40.0,
                             formHeadLine: "Add Company",
                             formInput: addCompany)
                
                // Add School
                EditCardForm(formHeight: 40.0,
                             formHeadLine: "Add School",
                             formInput: addSchool)
                
                Group {
                    // Basic Info
                    Text("Basic Info")
                        .font(.headline)
                    GenderSettings(genderPreference: $genderPreference)
                    AgeSettings(scaleMinAge:$scaleMinAge,
                                scaleMaxAge: $scaleMaxAge,
                                realMinAge: $realMinAge,
                                realMaxAge: $realMaxAge)
                    ReligionFilter(religionPreference: $religionPreference)
                    CommunityFilter(communityPreference: $communityPreference)
                    CareerFilter(careerPreference: $careerPreference)
                    EducationFilter(educationPreference: $educationPreference)
                    RaisedInFilter(countryPreference: $countryPreference)
                }
                
                Group {
                    // Discovery
                    VStack(alignment: .leading) {
                        Toggle(isOn: $discoveryStatus) {
                            Text("Discovery")
                                .font(.subheadline)
                            Image(systemName: "magnifyingglass")
                        }
                        Text("Found someone? Take a break, hide your card. You can still chat with your matches")
                            .font(.caption2)
                    }.padding([.top,.bottom],10)
                    
                    
                    // Notifications
                    VStack(alignment: .leading) {
                        Toggle(isOn: $notificationsStatus) {
                            Text("Notifications")
                                .font(.subheadline)
                            Image(systemName: "bell.fill")
                        }
                        Text("Want to be notified when you find a match, turn on that notification?")
                            .font(.caption2)
                    }.padding([.top,.bottom],10)
                }
                
                Group {
                    // Contact Support
                    ContactSupport()
                    
                    // Delete Profile
                    DeleteProfileButton()
                }
                .padding(.top,40)
                
                
            }.padding(.horizontal,20)
        })
    }
}

struct EditCardInfo_Previews: PreviewProvider {
    static var previews: some View {
        EditCardInfo()
    }
}
