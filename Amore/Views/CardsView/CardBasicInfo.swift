//
//  CardBasicInfo.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/10/21.
//

import SwiftUI

struct CardBasicInfo: View {
    
    let height: String
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
                    Text(height)
                        .font(.caption)
                    Spacer()
                }
                
                // Work
                HStack {
                    Image(systemName:"bag.fill")
                        .foregroundColor(Color.blue)
                    Text(work)
                        .font(.caption)
                    Spacer()
                }
                
                // Bachelors
                HStack {
                    Image(systemName:"graduationcap.fill")
                        .foregroundColor(Color.blue)
                    Text(education)
                        .font(.caption)
                    Spacer()
                }
                
                // Religion
                HStack {
                    Image(systemName:"book.fill")
                        .foregroundColor(Color.blue)
                    Text(religion)
                        .font(.caption)
                    Spacer()
                }
                
                // Politics
                HStack {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(Color.blue)
                    Text(politics)
                        .font(.caption)
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


