//
//  FilterSettings.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import SwiftUI

struct FilterSettings: View {
    
    
    var careerList = ["Accommodation and Food Services", "Arts, Entertainment and Recreation", "Automobile", "Construction", "Consumer Services", "Education", "Energy", "Fashion", "Finance", "Government", "Healthcare", "Information", "Law Professional", "Manufacturing", "Media & Entertainment", "Mining", "Real Estate", "Retail Trade", "Space", "Start Up", "Student","Technology", "Transportation","All (Default)"]
    
    
    var religionsList = ["Atheism", "Bahá'í", "Buddhism", "Christianity", "Confucianism", "Druze", "Gnosticism", "Hinduism",
                         "Islam", "Jainism", "Judaism", "Rastafarianism", "Shinto", "Sikhism", "Zoroastrianism",
                         "Traditional African Religions", "African Diaspora Religions", "Indigenous American Religion", "All (Default)"]
    
    var educationList = ["Doctorate",
                         "Masters",
                         "Bachelors",
                         "Associates",
                         "Trade School",
                         "High School",
                         "No Education",
                         "All (Default)"]
    
    var countryPreferenceList = ["India",
                                 "United States",
                                 "Canada",
                                 "China",
                                 "Japan",
                                 "Germany",
                                 "United Kingdom",
                                 "France",
                                 "Brazil",
                                 "Itlay",
                                 "Russia",
                                 "South Korea",
                                 "Australia","Spain","Mexico","Indonesia","Turkey","Netherlands",
                                 "Saudi Arabia","Switzerland","Argentina","Sweden","Poland","Belgium",
                                 "Thailand","Iran","Austria","Norway","United Arab Emirates","Nigeria",
                                 "Israel","Asia","Europe","North America","South America","All (Default)"]

    var politicalPreferenceList = ["Far Left","Left Wing","Moderate Left","Independent","Moderate Right","Right Wing","Far Right","All (Default)"]
    var smokerPreferenceList = ["Socially","Sometimes","Never","All (Default)"]
    var drinkPreferenceList = ["Socially","Sometimes","Never","All (Default)"]
    
    var countries: [String] = []
    
    @State var contentHasScrolled = false
    
    // User Filter Settings
    @EnvironmentObject var filterModel: FilterModel
    @EnvironmentObject var cardProfileModel: CardProfileModel
    
    @State var minAgeFilter : Int = 21
    @State var maxAgeFilter : Int = 28
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                content
                    .background(Image("Blob 1").offset(x: -180, y: 300))
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var content: some View {
        ScrollView {
            
            VStack(alignment: .leading) {
                
                // Group 1: Creating groups to not exceed the max # of components in a Stack
                Group {
                    // Gender Filter
                    NavigationLink(
                          destination: SelectSingleItem(selection:$filterModel.filterData.genderPreference.bound,
                                                        optionsList:["Male", "Female", "All (Default)"],
                                                        filterName:"Gender").padding(20),
                          label: {
                                  FilterCommonContainer(filterName:"Gender",
                                                        filteredValue:"Modify")
                        })
                    
                    // Age Filter
                    AgeSettings(minAgeFilter:$filterModel.filterData.minAgePreference.boundInt,
                                maxAgeFilter:$filterModel.filterData.maxAgePreference.boundInt)
                        
                    
                    // Religion Filter
                    NavigationLink(
                        destination: SelectMultipleItems(selectionList:$filterModel.filterData.religionPreference.boundStringArray,
                                                        optionsList:religionsList,
                                                        filterName:"Religion").padding(20),
                        label: {
                                FilterCommonContainer(filterName:"Religion",
                                                      filteredValue:"Modify")
                    })
                    
                    // Career Filter
                    NavigationLink(
                        destination: SelectMultipleItems(selectionList:$filterModel.filterData.careerPreference.boundStringArray,
                                                        optionsList:careerList,
                                                         filterName:"Career").padding(20),
                        label: {
                                FilterCommonContainer(filterName:"Career",
                                                      filteredValue:"Modify")
                    })
                    
                    // Education Filter
                    NavigationLink(
                        destination: SelectMultipleItems(selectionList:$filterModel.filterData.educationPreference.boundStringArray,
                                                        optionsList:educationList,
                                                         filterName:"Education").padding(20),
                        label: {
                                FilterCommonContainer(filterName:"Education",
                                                      filteredValue:"Modify")
                    })
                    
                    // Country Filter
                    NavigationLink(
                        destination: SelectMultipleItems(selectionList:$filterModel.filterData.countryPreference.boundStringArray,
                                                        optionsList:countryPreferenceList,
                                                         filterName:"Raised In").padding(20),
                        label: {
                                FilterCommonContainer(filterName:"Raised In",
                                                      filteredValue:"Modify")
                    })
                    
                }
                
                // Group 2
                Group {
                    // Political Prefernce Filter
                    NavigationLink(
                        destination: SelectMultipleItems(selectionList:$filterModel.filterData.politicalPreference.boundStringArray,
                                                        optionsList:politicalPreferenceList,
                                                         filterName:"Politics").padding(20),
                        label: {
                                FilterCommonContainer(filterName:"Politics",
                                                      filteredValue:"Modify")
                    })
                    
                    // Smoker Filter
                    NavigationLink(
                        destination: SelectMultipleItems(selectionList:$filterModel.filterData.smoker.boundStringArray,
                                                        optionsList:smokerPreferenceList,
                                                         filterName:"Smoker").padding(20),
                        label: {
                                FilterCommonContainer(filterName:"Smoker",
                                                      filteredValue:"Modify")
                    })
                    
                    // Drinks Filter
                    NavigationLink(
                        destination: SelectMultipleItems(selectionList:$filterModel.filterData.drink.boundStringArray,
                                                        optionsList:drinkPreferenceList,
                                                         filterName:"Drink").padding(20),
                        label: {
                                FilterCommonContainer(filterName:"Drink",
                                                      filteredValue:"Modify")
                    })
                        
                    // Radius
                    RadiusFilter()
                        .environmentObject(cardProfileModel)
                        .environmentObject(filterModel)
                }
                
                Spacer()
             
            }
            .padding(20)
        }
        .coordinateSpace(name: "scroll")
        
    }
    
}



struct FilterSettings_Previews: PreviewProvider {
    static var previews: some View {
        FilterSettings()
            .environmentObject(FilterModel())
            .environmentObject(CardProfileModel())
            
    }
}
