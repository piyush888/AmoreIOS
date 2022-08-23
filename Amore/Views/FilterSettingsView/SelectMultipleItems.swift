//
//  SelectMultipleItems.swift
//  Amore
//
//  Created by Kshitiz Sharma on 7/21/22.
//

import SwiftUI

struct SelectMultipleItems : View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchTerm: String = ""
    @Binding var selectionList: [String]
    @State var optionsList: [String]
    @State var filterName: String
    
    var filteredOptionsList: [String] {
        self.optionsList.filter {
            searchTerm.isEmpty ? true : $0.lowercased().contains(searchTerm.lowercased())
        }
    }
    
    var body: some View {
            
            VStack {
                ScrollView(showsIndicators: false) {
                    
                    SearchBar(text: $searchTerm, placeholder: "Search \(filterName)")
                    
                    ForEach(filteredOptionsList, id: \.self) { option in
                        Button {
                            // Add/Remove to selection list
                            if self.selectionList.contains("\(option)") {
                                // Remove if button clicked again
                                if let index = self.selectionList.firstIndex(of: option) {
                                    self.selectionList.remove(at: index)
                                }
                            } else {
                                // Add if selection doesn't exist in list, add it to list
                                self.selectionList.append(option)
                            }
                            
                        } label : {
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(colorScheme == .dark ? Color(hex: 0x24244A): Color(hex: 0xe8f4f8))
                                    .frame(height:45)
                                
                                HStack {
                                    Text(option)
                                        .font(.subheadline)
                                        .padding(.horizontal,20)
                                    Spacer()
                                    if self.selectionList.contains("\(option)") {
                                        Image(systemName: "checkmark").padding(.horizontal,10)
                                    }
                                }
                            }
                            .foregroundColor(.accentColor)
                        }
                    }
                }
        }
        .navigationTitle("\(filterName)")
        .navigationBarTitleDisplayMode(.inline)
    
    }
}


struct SelectMultipleItems_Previews: PreviewProvider {
    
    
    static var previews: some View {
        
        SelectMultipleItems(selectionList:Binding.constant(["Any"]),
                            optionsList:["Media & Entertainment",
                                         "Fashion",
                                         "Arts, Entertainment and Recreation",
                                         "Education",
                                         "Healthcare",
                                         "Accommodation and Food Services",
                                         "Technology",
                                         "Construction",
                                         "Real Estate",
                                         "Retail Trade",
                                         "Energy",
                                         "Finance",
                                         "Information",
                                         "Mining",
                                         "Manufacturing",
                                         "Government",
                                         "Automobile",
                                         "Consumer Services",
                                         "Transportation",
                                         "Law Professional",
                                         "Any"],
                            filterName:"Career")
    }
}

