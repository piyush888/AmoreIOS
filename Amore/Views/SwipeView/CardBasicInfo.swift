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
    let politics: String
    let location: String
    
    let adaptivecolumns = Array(repeating:
                                    GridItem(.adaptive(minimum: 150),
                                             spacing: 5,
                                             alignment: .center),count: 2)
    var body: some View {
        
        VStack(alignment:.leading) {
            
            Text("About me")
                .font(.BoardingTitle2)
            
            
            LazyVGrid(columns: adaptivecolumns, alignment: .leading, spacing: 8, content: {
                
                // Height of the profile
                HStack {
                    Image(systemName:"arrow.up.square.fill")
                        .foregroundColor(Color.blue)
                    
                    if height > 0.0 {
                        Text(String(height))
                            .font(.caption)
                    } else {
                        RequestData(property:"height")
                    }
                    
                    Spacer()
                }
                
                // Work
                HStack {
                    Image(systemName:"bag.fill")
                        .foregroundColor(Color.blue)
                    if work != "" {
                        Text(work)
                            .font(.caption)
                    } else {
                        RequestData(property:"work")
                    }
                    
                    Spacer()
                }
                
                // Bachelors
                HStack {
                    Image(systemName:"graduationcap.fill")
                        .foregroundColor(Color.blue)
                    
                    if education != "" {
                        Text(education)
                            .font(.caption)
                    } else {
                        RequestData(property:"Education")
                    }
                    Spacer()
                }
                
                // Religion
                HStack {
                    Image(systemName:"book.fill")
                        .foregroundColor(Color.blue)
                    
                    if religion != "" {
                        Text(religion)
                            .font(.caption)
                    } else {
                        RequestData(property:"Religion")
                    }
                    
                    Spacer()
                }
                
                // Politics
                HStack {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(Color.blue)
                    
                    if politics != "" {
                        Text(politics)
                            .font(.caption)
                    } else {
                        RequestData(property:"Politics")
                    }
                    Spacer()
                }
                
                // Location
                HStack {
                    Image(systemName: "house.fill")
                        .foregroundColor(Color.blue)
                    Text(location)
                        .font(.caption)
                    Spacer()
                }
            })
            
        }
    }
}


struct CardBasicInfo_Previews: PreviewProvider {
    static var previews: some View {
        
        CardBasicInfo(height: 0.0,
                      work: "",
                      education: "",
                      religion: "",
                      politics: "",
                      location: "")
    }
}
