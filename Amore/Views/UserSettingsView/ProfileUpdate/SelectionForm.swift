//
//  SelectionForm.swift
//  Amore
//
//  Created by Kshitiz Sharma on 7/25/22.
//

import SwiftUI

struct SelectionForm: View {
    
    @Binding var selection: String
    @State var formName: String
    @State var selectionsList: [String]
    @Binding var formUpdated: Bool
    
    var body: some View {
        
         Picker("\(formName)", selection: $selection) {
                ForEach(selectionsList, id: \.self) {
                    Text($0).tag($0)
                }
            }
            .onChange(of: selection) { _ in
                print("Tag Value selected: \(selection) for \(formName)")
                self.formUpdated = true
            }
    }
}

struct SelectionForm_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SelectionForm(selection:Binding.constant("Red"),
                          formName:"Test",
                          selectionsList:["Red","Yellow","Blue"],
                          formUpdated:Binding.constant(false))
        }
    }
}
