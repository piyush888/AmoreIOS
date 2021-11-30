//
//  WorkAndSchool.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/29/21.
//

import SwiftUI

struct WorkAndSchool: View {
    
    let work: String
    let jobTitle: String
    let education: String
    let school: String
    
    var body: some View {
            
        VStack(alignment: .leading) {
            
                Spacer()
                
                VStack(alignment:.leading){
                        HStack(spacing:10) {
                            Image(systemName: "building.columns.fill")
                                .foregroundColor(Color.blue)
                            Text("\(jobTitle) at \(work)")
                                .font(.subheadline)
                        }
                        .padding()
                }
                    
                
                VStack(alignment:.leading){
                        HStack(spacing:10) {
                            Image(systemName: "building.2.fill")
                                .foregroundColor(Color.blue)
                            Text("\(education) from \(school)")
                                .font(.subheadline)
                        }
                        .padding()
                }
                    
                    
                Spacer()
            
            }
            .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .topLeading
            )
            .background(Color(hex: 0xe8f4f8))
            .cornerRadius(20)
    
    }
}

struct WorkAndSchool_Previews: PreviewProvider {
    static var previews: some View {
        WorkAndSchool(work:"VP",
                      jobTitle:"Bank of America",
                      education:"MS",
                      school:"Harvard University")
            .padding()
    }
}
