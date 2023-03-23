//
//  CardBasicInfo.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/10/21.
//

import SwiftUI

struct CardBasicInfo: View {
    
    let height: Double
    let education: String
    let countryRaisedIn: String
    let religion: String
    let industry: String
    let politics: String
    let food: String
    
    let adaptivecolumns = Array(repeating:GridItem(.adaptive(minimum: 150),
                                             spacing: 5,
                                             alignment: .center),count: 2)
    var showHeadline: Bool {
        if(height != 0.0 || education != "" || countryRaisedIn != "" || industry != "" || politics != "" || food != "") {
            return true
        }
        return false
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            if showHeadline {
                Text("About me")
                    .bold()
            }
                
            LazyVGrid(columns: adaptivecolumns, alignment: .leading, spacing: 8, content: {
                
                // Height of the profile
                if(height != 0.0) {
                    ChildCardBasicInfo(iconStringName: "arrow.up.square.fill",
                                       data: String(format: "%.1f",height*0.0328) + " ft",
                                       fieldName:"Height")
                }
                
                // Bachelors
                if(education != "") {
                    ChildCardBasicInfo(iconStringName: "graduationcap.fill",
                                       data: education,
                                       fieldName:"Education")
                }
                
                // Location
                if(countryRaisedIn != "") {
                    ChildCardBasicInfo(iconStringName: "globe",
                                       data: countryRaisedIn,
                                       fieldName:"Home")
                }
                
                // Politics
                if(politics != "") {
                    ChildCardBasicInfo(iconStringName: "person.3.fill",
                                       data: politics,
                                   fieldName:"Politics")
                }
                
                // Work
                if(industry != "") {
                    ChildCardBasicInfo(iconStringName:  "bag.fill",
                                       data: industry,
                                       fieldName:"Work")
                }
                
                
                // Food
                if(food != "") {
                    ChildCardBasicInfo(iconStringName: "fork.knife",
                                       data: food,
                                       fieldName:"Food")
                }
                
//                // Religion
//                ChildCardBasicInfo(iconStringName: "book.fill",
//                                   data: religion,
//                                   fieldName:"Religion")
                
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
                .help(fieldName)
            Text(self.data)
                .font(.caption)
            Spacer()
        }
        .frame(minWidth: 150, idealWidth: UIScreen.main.bounds.width/2-25, maxWidth: UIScreen.main.bounds.width/2, alignment: .leading)
        .fixedSize()
    }
}

struct CardBasicInfo_Previews: PreviewProvider {
    static var previews: some View {
        CardBasicInfo(height: 178,
                      education: "graduated from masters program at ASU",
                      countryRaisedIn: "India",
                      religion: "Hinduism",
                      industry: "computer/hardware/software",
                      politics: "Liberal",
                      food: "Vegetarian")
    }
}
