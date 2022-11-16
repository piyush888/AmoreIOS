//
//  FilterCommonContainer.swift
//  Amore
//
//  Created by Kshitiz Sharma on 7/15/22.
//
import SwiftUI

struct FilterCommonContainer: View {
        
    @State var filterName: String
    @State var filteredValue: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        HStack {
            Text("\(filterName)")
                .padding(.horizontal)
                
            Spacer()
            Text("\(filteredValue)")
                .padding()
        }
        .padding(10)
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(LinearGradient(gradient: Gradient(colors: [Color(hex:0x452A7B), Color(hex:0xFF6EE0)]),
                                     startPoint: .bottomLeading,
                                       endPoint: .top))
        )
        .foregroundColor(Color.white)
    }
    
}

struct FilterCommonContainer_Preview: PreviewProvider {
    static var previews: some View {
        FilterCommonContainer(filterName:"Gender",filteredValue:"20")
    }
}

