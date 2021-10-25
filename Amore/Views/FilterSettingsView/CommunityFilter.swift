//
//  CommunityFilter.swift
//  Amore
//
//  Created by Piyush Garg on 21/10/21.
//

import SwiftUI

struct CommunityFilter: View {
    
    @Binding var communityPreference: [String]
    @State var displayCommunityInTab : String = "Modify community"
    
    var body: some View {
        NavigationLink(
            destination: CommunityOptions(communityPreference:$communityPreference,
                                         displayCommunityInTab: $displayCommunityInTab),
            label: {
                ZStack{
                    CommonContainer()
                    HStack {
                        
                        Text("Community")
                            .font(.subheadline)
                            .foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Text("\(self.displayCommunityInTab)")
                    }
                    .padding(.horizontal,20)
                }
            })
    }
}

struct CommunityOptions : View {
    
    var religionsList = ["Any","Gujarati","Jatt","Punjabi","Sunni","Shia","Hindi Speaking","Sindhi","Bengali","Tamil", "Telugu", "Malayali", "Maharashtrian", "Kannada"]
    @Binding var communityPreference: [String]
    @Binding var displayCommunityInTab: String
    
    func updateDisplayReligionInFilter () {
        if(self.communityPreference.count >= 2) {
            self.displayCommunityInTab = self.communityPreference[0...1].joined(separator: ", ")
        } else if(self.communityPreference.count == 1) {
            self.displayCommunityInTab = self.communityPreference[0]
        } else {
            self.communityPreference = ["Any"]
        }
    }
    
    var body: some View {
        
        VStack {
            
            Text("Community")
                .font(.title)
            ScrollView {
                ForEach(religionsList, id: \.self) { religion in
                    
                    Button(action: {
                        // Add/Remove to passionSelected
                        if self.communityPreference.contains("\(religion)") {
                            // Remove if button clicked again
                            if let index = self.communityPreference.firstIndex(of: religion) {
                                self.communityPreference.remove(at: index)
                            }
                        } else {
                            // Add if passion doesn't exist in list
                            self.communityPreference.append(religion)
                        }
                        updateDisplayReligionInFilter()
                    }) {
                        
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
                                
                                if self.communityPreference.contains("\(religion)") {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                        .padding(.horizontal,10)
                                }
                                
                            }
                            
                        }
                        
                    }
                }
            }
            
            
            
            Spacer()
            
        }
        .padding(.horizontal,20)
    }
}

struct CommunityFilter_Previews: PreviewProvider {
    static var previews: some View {
        CommunityFilter(communityPreference: Binding.constant(["Bengali"]))
    }
}
