//
//  WorkAndSchool.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/29/21.
//

import SwiftUI

struct WorkAndSchool: View {
    
    let jobTitle: String
    let work: String
    let education: String
    let school: String
    @Environment(\.colorScheme) var colorScheme

    
    // work: name of the company
    // jobTile: title of the guy
    // education: what's the level of graduation
    // school: name of the school the person went to
    var body: some View {
            
        VStack(alignment: .leading) {
            
            Spacer()
            
                // If both company and job title is available
                if self.work != "" && self.jobTitle != "" {
                    WorkSchoolDescription(icon: "building.2.fill",
                                          details: "\(jobTitle) at \(work)")
                } else {
                    // If only job title is available
                    if self.work == "" && self.jobTitle != "" {
                        WorkSchoolDescription(icon: "building.2.fill",
                                              details: "\(jobTitle)")
                    } else if self.jobTitle == ""  && self.work != "" {
                        // If only work is available
                        WorkSchoolDescription(icon: "building.2.fill",
                                              details: "Works at \(work)")
                    }
                }
            
            
            
                // If both education & school is present
                if self.education != "" && self.school != "" {
                    WorkSchoolDescription(icon: "building.columns.fill",
                                          details: "\(education) from \(school)")
                } else {
                    // If only school is present
                    if self.education == "" && self.school != ""  {
                        WorkSchoolDescription(icon: "building.columns.fill",
                                              details: "Studied at \(self.school)")
                    } else if self.school == "" && self.education != "" {
                        // If only education is present
                        WorkSchoolDescription(icon: "building.columns.fill",
                                              details: "\(self.education)")
                    }
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
            .cornerRadius(20)
    }
}


struct WorkSchoolDescription: View {
        
    @State var icon: String
    @State var details: String
    
    var body: some View {
        VStack(alignment:.leading) {
                HStack(spacing:10) {
                    Image(systemName: icon)
                        .foregroundColor(Color.blue)
                    Text("\(details)")
            }
            .padding()
        }
    }
}


struct WorkAndSchool_Previews: PreviewProvider {
    static var previews: some View {
        WorkAndSchool(jobTitle:"VP",
                      work:"Bank of America",
                      education:"MS",
                      school:"Harvard University")
            .padding()
        
        // No
        WorkAndSchool(jobTitle:"",
                      work:"Bank of America",
                      education:"",
                      school:"Harvard University")
            .padding()
        
        WorkAndSchool(jobTitle:"VP",
                      work:"",
                      education:"MS",
                      school:"")
            .padding()
    }
}
