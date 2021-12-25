//
//  CardBasicInfo.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/10/21.
//

import SwiftUI

struct CardBasicInfo: View {
    
    let height: Double
    let work: String
    let education: String
    let religion: String
    let profileCompletion: Double
    let countryRaisedIn: String
    
    let adaptivecolumns = Array(repeating:
                                    GridItem(.adaptive(minimum: 150),
                                             spacing: 5,
                                             alignment: .center),count: 2)
    var body: some View {
        
        VStack(alignment:.leading) {
            
            Text("About me")
                .bold()
                
            LazyVGrid(columns: adaptivecolumns, alignment: .leading, spacing: 8, content: {
                
                // Height of the profile
                ChildCardBasicInfo(iconStringName: "arrow.up.square.fill",
                                   // cm to feet
                                   data: String(format:"%.1f", height/30.48),
                                   fieldName:"Height")
                // Work
                ChildCardBasicInfo(iconStringName: "bag.fill",
                                   data: work,
                                   fieldName:"Work")
                // Bachelors
                ChildCardBasicInfo(iconStringName: "graduationcap.fill",
                                   data: education,
                                   fieldName:"Education")
                // Religion
                ChildCardBasicInfo(iconStringName: "book.fill",
                                   data: religion,
                                   fieldName:"Religion")
                
                // Politics
                ChildCardBasicInfo(iconStringName: "speedometer",
                                   data: String(format:"%.2f",profileCompletion) + "%",
                                   fieldName:"Profile Completed")
                // Location
                ChildCardBasicInfo(iconStringName: "house.fill",
                                   data: countryRaisedIn,
                                   fieldName:"Home")
                
            })
            
        }
    }
}


struct ChildCardBasicInfo : View {
    
    @State var iconStringName: String
    @State var data: String
    @State var fieldName: String
    
    var body: some View {
        
            HStack {
                Image(systemName: self.iconStringName)
                    .foregroundColor(Color.blue)
                Text(self.data)
                    .font(.caption)
                Spacer()
            }.onAppear {
                if self.data == "" {
                    self.data = "No \(self.fieldName)"
                }
            }
        
    }
    
}

struct CardBasicInfo_Previews: PreviewProvider {
    static var previews: some View {
        
        CardBasicInfo(height: 0.0,
                      work: "",
                      education: "",
                      religion: "",
                      profileCompletion: 0.0,
                      countryRaisedIn: "")
    }
}
