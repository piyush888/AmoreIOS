//
//  FilterCommonList.swift
//  Amore
//
//  Created by Kshitiz Sharma on 7/16/22.
//

import SwiftUI

struct SelectSingleItem : View {
    
    @Binding var selection: String
    @State var optionsList: [String]
    @State var filterName: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        
            VStack {
                ForEach(optionsList, id: \.self) { option in
                    Button{
                        selection = option
                    } label : {
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(colorScheme == .dark ? Color(hex: 0x24244A): Color(hex: 0xe8f4f8))
                                .frame(height:45)
                                
                            HStack {
                                Text(option)
                                    .font(.subheadline)
                                    .padding(.horizontal,20)
                                
                                Spacer()
                                
                                if option == selection {
                                    Image(systemName: "checkmark")
                                        .padding(.horizontal,10)
                                }
                            }
                        }
                        .foregroundColor(.accentColor)
                    }
                    
                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("\(filterName)")
            .navigationBarTitleDisplayMode(.inline)
        
    }
}


struct SelectSingleItem_Previews: PreviewProvider {
    static var previews: some View {
        SelectSingleItem(selection:Binding.constant("Male"),
                           optionsList:["Male", "Female", "All"],
                           filterName:"Gender")
    }
}
