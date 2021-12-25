//
//  FilterSettings.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import SwiftUI

struct FilterSettings: View {
    
    // User Filter Settings
    @EnvironmentObject var filterModel: FilterModel
    
    @State var minAgeFilter : Int = 21
    @State var maxAgeFilter : Int = 28
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading) {
                
                Text("Filters")
                    .foregroundColor(.orange)
                    
                //
                GenderSettings(genderPreference: $filterModel.filterData.genderPreference.bound)
                
                
                AgeSettings(minAgeFilter:$filterModel.filterData.minAgePreference.boundInt,
                            maxAgeFilter:$filterModel.filterData.maxAgePreference.boundInt)
                
                ReligionFilter(religionPreference: $filterModel.filterData.religionPreference.boundStringArray)
                CommunityFilter(communityPreference: $filterModel.filterData.communityPreference.boundStringArray)
                CareerFilter(careerPreference: $filterModel.filterData.careerPreference.boundStringArray)
                EducationFilter(educationPreference: $filterModel.filterData.educationPreference.bound)
                RaisedInFilter(countryPreference: $filterModel.filterData.countryPreference.bound)
                
                Spacer()
             
            }
            .padding(.top,10)
            .padding(.horizontal)
            .navigationBarHidden(true)
        }
    }
}

struct FilterSettings_Previews: PreviewProvider {
    static var previews: some View {
        FilterSettings()
    }
}
