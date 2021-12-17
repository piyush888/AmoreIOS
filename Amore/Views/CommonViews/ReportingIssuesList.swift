//
//  ReportingIssuesCard.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/16/21.
//

import SwiftUI

struct ReportingIssuesCard: View {
    @Binding var safetyButton: Bool
    
    @State private var selection = "Red"
    let colors = ["Red", "Green", "Blue", "Black", "Tartan"]

    
    var body: some View {
        
        NavigationView {
                    VStack {
                        
                        Picker("Select a paint color", selection: $selection) {
                               ForEach(colors, id: \.self) {
                                   Text($0)
                               }
                           }
                           .pickerStyle(.menu)
                    
                    }
                    .navigationBarItems(trailing: Button(action: {
                        self.safetyButton.toggle()
                    }) {
                        Text("Done").bold()
                    })
            }
        
       
    }
}

struct ReportingIssuesCard_Previews: PreviewProvider {
    static var previews: some View {
        ReportingIssuesCard(safetyButton:Binding.constant(false))
    }
}

