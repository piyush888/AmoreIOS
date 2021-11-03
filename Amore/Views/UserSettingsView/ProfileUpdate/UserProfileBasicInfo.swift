//
//  UserProfileBasicInfo.swift
//  Amore
//
//  Created by Piyush Garg on 28/10/21.
//

import SwiftUI

struct UserProfileBasicInfo: View {
    
    @Binding var genderPreference: String?
    @Binding var religionPreference: String?
    @Binding var communityPreference: String?
    @Binding var careerPreference: String?
    @Binding var educationPreference: String?
    @Binding var countryPreference: String?
    
    var body: some View {
        GenderInfo(genderPreference: $genderPreference)
        ReligionInfo(religionPreference: $religionPreference)
        CommunityInfo(communityPreference: $communityPreference)
        CareerInfo(careerPreference: $careerPreference)
        EducationInfo(educationPreference: $educationPreference)
        RaisedInInfo(countryPreference: $countryPreference)
    }
}

struct GenderInfo: View {
    
    @Binding var genderPreference: String?
    @State private var showingSheet = false
    
    var body: some View {
        
        Button {
            showingSheet.toggle()
        } label : {
            ZStack{
                CommonContainer()
                HStack {
                    
                    Text("Gender")
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Text("\(self.genderPreference ?? "Modify Gender")")
                }
                .padding(.horizontal,20)
            }
        }.sheet(isPresented: $showingSheet) {
            ShowGendersInfo(genderPreference:$genderPreference,
                            showSheetView:$showingSheet)
        }
    }
}

struct ShowGendersInfo : View {
    
    @Binding var genderPreference: String?
    @Binding var showSheetView: Bool
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("Gender")
                    .font(.title3)
                Spacer()
                Button {
                    self.showSheetView = false
                    
                } label: {
                    Text("Done")
                }
            }
            
            ForEach(["Male", "Female", "All"], id: \.self) { gender in
                Button{
                    genderPreference = gender
                } label : {
                    ZStack{
                        Rectangle()
                            .cornerRadius(5.0)
                            .frame(height:45)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.pink, lineWidth: 1))
                        
                        HStack {
                            Text(gender)
                                .foregroundColor(.black)
                                .font(.BoardingSubHeading)
                                .padding(.horizontal,10)
                            
                            Spacer()
                            
                            if gender == genderPreference {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .padding(.horizontal,10)
                            }
                            
                        }
                        
                    }
                }
            }
            
            Spacer()
            
        }
        .padding(20)
    }
}

struct ReligionInfo: View {
    
    @Binding var religionPreference: String?
    @State private var showingSheet = false
    
    var body: some View {
        
        Button {
            showingSheet.toggle()
        } label : {
            ZStack{
                CommonContainer()
                HStack {
                    
                    Text("Religion")
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Text("\(self.religionPreference ?? "Modify Religion")")
                }
                .padding(.horizontal,20)
            }
        }.sheet(isPresented: $showingSheet) {
            ReligionInfoOptions(religionPreference:$religionPreference,
                            showSheetView:$showingSheet)
        }
    }
}

struct ReligionInfoOptions : View {
    
    var religionsList = ["Any","Sikh","Hindu","Islam","Jain","Christian","Buddhist","Spiritual","Other","No Religion"]
    @Binding var religionPreference: String?
    @Binding var showSheetView: Bool
    
    var body: some View {
        
        VStack {
                
            HStack {
                Text("Religion")
                    .font(.title3)
                Spacer()
                Button {
                    self.showSheetView = false
                    
                } label: {
                    Text("Done")
                }
            }
            
            ForEach(religionsList, id: \.self) { religion in
                Button{
                    religionPreference = religion
                } label : {
                    ZStack{
                        Rectangle()
                            .cornerRadius(5.0)
                            .frame(height:45)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.pink, lineWidth: 1))
                        
                        HStack {
                            Text(religion)
                                .foregroundColor(.black)
                                .font(.BoardingSubHeading)
                                .padding(.horizontal,10)
                            
                            Spacer()
                            
                            if religion == religionPreference {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .padding(.horizontal,10)
                            }
                            
                        }
                        
                    }
                }
            }
            
            Spacer()
            
        }
        .padding(20)
    }
}

struct CommunityInfo: View {
    
    @Binding var communityPreference: String?
    @State private var showingSheet = false
    
    var body: some View {
        
        Button {
            showingSheet.toggle()
        } label : {
            ZStack{
                CommonContainer()
                HStack {
                    
                    Text("Community")
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Text("\(self.communityPreference ?? "Modify Community")")
                }
                .padding(.horizontal,20)
            }
        }.sheet(isPresented: $showingSheet) {
            CommunityInfoOptions(communityPreference:$communityPreference,
                            showSheetView:$showingSheet)
        }
    }
}

struct CommunityInfoOptions : View {
    
    var communityList = ["Any","Gujarati","Jatt","Punjabi","Sunni","Shia","Hindi Speaking","Sindhi","Bengali","Tamil", "Telugu", "Malayali", "Maharashtrian", "Kannada"]
    @Binding var communityPreference: String?
    @Binding var showSheetView: Bool
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Community")
                    .font(.title3)
                Spacer()
                Button {
                    self.showSheetView = false
                    
                } label: {
                    Text("Done")
                }
            }
            
            ForEach(communityList, id: \.self) { community in
                Button{
                    communityPreference = community
                } label : {
                    ZStack{
                        Rectangle()
                            .cornerRadius(5.0)
                            .frame(height:45)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.pink, lineWidth: 1))
                        
                        HStack {
                            Text(community)
                                .foregroundColor(.black)
                                .font(.BoardingSubHeading)
                                .padding(.horizontal,10)
                            
                            Spacer()
                            
                            if community == communityPreference {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .padding(.horizontal,10)
                            }
                            
                        }
                        
                    }
                }
            }
            
            Spacer()
            
        }
        .padding(20)
    }
    
}

struct CareerInfo: View {
    
    @Binding var careerPreference: String?
    @State private var showingSheet = false
    
    var body: some View {
        
        Button {
            showingSheet.toggle()
        } label : {
            ZStack{
                CommonContainer()
                HStack {
                    
                    Text("Career")
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Text("\(self.careerPreference ?? "Modify Career")")
                }
                .padding(.horizontal,20)
            }
        }.sheet(isPresented: $showingSheet) {
            CareerInfoOptions(careerPreference:$careerPreference,
                            showSheetView:$showingSheet)
        }
        
    }
}

struct CareerInfoOptions : View {
    
    var careerList = ["Any","Account Executive","Accountant","Actor","Aerospace Engineer","Agriculturist","Analyst","Anesthesiologist","Archeologist","Architect", "Artist", "Attorney", "Aviation Professional", "Banker"]
    @Binding var careerPreference: String?
    @Binding var showSheetView: Bool
    
    var body: some View {
        
        VStack {
                
            HStack {
                Text("Career")
                    .font(.title3)
                Spacer()
                Button {
                    self.showSheetView = false
                    
                } label: {
                    Text("Done")
                }
            }
            
            ForEach(careerList, id: \.self) { career in
                Button{
                    careerPreference = career
                } label : {
                    ZStack{
                        Rectangle()
                            .cornerRadius(5.0)
                            .frame(height:45)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.pink, lineWidth: 1))
                        
                        HStack {
                            Text(career)
                                .foregroundColor(.black)
                                .font(.BoardingSubHeading)
                                .padding(.horizontal,10)
                            
                            Spacer()
                            
                            if career == careerPreference {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .padding(.horizontal,10)
                            }
                            
                        }
                        
                    }
                }
            }
            
            Spacer()
            
        }
        .padding(20)
    }
}

struct EducationInfo: View {
    
    @Binding var educationPreference: String?
    @State private var showingSheet = false
    
    var body: some View {
        
        Button {
            showingSheet.toggle()
        } label : {
            ZStack{
                CommonContainer()
                HStack {
                    
                    Text("Education")
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Text("\(self.educationPreference ?? "Modify Education")")
                }
                .padding(.horizontal,20)
            }
        }.sheet(isPresented: $showingSheet) {
            ShowEducationClassesInfo(educationPreference:$educationPreference,
                            showSheetView:$showingSheet)
        }
    }
}

struct ShowEducationClassesInfo : View {
    
    @Binding var educationPreference: String?
    @Binding var showSheetView: Bool
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("Education")
                    .font(.title3)
                Spacer()
                Button {
                    self.showSheetView = false
                    
                } label: {
                    Text("Done")
                }
            }
            
            ForEach(["Any", "Doctorate", "Masters", "Bachelors", "Associates", "Trade School", "High School", "No Education"], id: \.self) { gender in
                Button{
                    educationPreference = gender
                } label : {
                    ZStack{
                        Rectangle()
                            .cornerRadius(5.0)
                            .frame(height:45)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.pink, lineWidth: 1))
                        
                        HStack {
                            Text(gender)
                                .foregroundColor(.black)
                                .font(.BoardingSubHeading)
                                .padding(.horizontal,10)
                            
                            Spacer()
                            
                            if gender == educationPreference {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .padding(.horizontal,10)
                            }
                            
                        }
                        
                    }
                }
            }
            
            Spacer()
            
        }
        .padding(20)
    }
}

struct RaisedInInfo: View {
    
    @Binding var countryPreference: String?
    @State private var showingSheet = false
    
    var body: some View {
        
        Button {
            showingSheet.toggle()
        } label : {
            ZStack{
                CommonContainer()
                HStack {
                    
                    Text("Raised In")
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Text("\(self.countryPreference ?? "Modify Country")")
                }
                .padding(.horizontal,20)
            }
        }.sheet(isPresented: $showingSheet) {
            ShowCountriesInfo(countryPreference:$countryPreference,
                            showSheetView:$showingSheet)
        }
    }
}

struct ShowCountriesInfo : View {
    
    @Binding var countryPreference: String?
    @Binding var showSheetView: Bool
    
    var body: some View {
        
        VStack {
                
            HStack {
                Text("Raised In")
                    .font(.title3)
                Spacer()
                Button {
                    self.showSheetView = false
                    
                } label: {
                    Text("Done")
                }
            }
                    
            ForEach(["Any", "United States", "Canada", "United Kingdom", "Australia", "India", "United Arab Emirates", "Other"], id: \.self) { gender in
                Button{
                    countryPreference = gender
                } label : {
                    ZStack{
                        Rectangle()
                            .cornerRadius(5.0)
                            .frame(height:45)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.pink, lineWidth: 1))
                        
                        HStack {
                            Text(gender)
                                .foregroundColor(.black)
                                .font(.BoardingSubHeading)
                                .padding(.horizontal,10)
                            
                            Spacer()
                            
                            if gender == countryPreference {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .padding(.horizontal,10)
                            }
                            
                        }
                        
                    }
                }
            }
            
            Spacer()
            
        }
        .padding(20)
    }
}

struct UserProfileBasicInfo_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileBasicInfo(genderPreference: Binding.constant("Any"), religionPreference: Binding.constant("Any"), communityPreference: Binding.constant("Any"), careerPreference: Binding.constant("Any"), educationPreference: Binding.constant("Any"), countryPreference: Binding.constant("Any"))
    }
}
