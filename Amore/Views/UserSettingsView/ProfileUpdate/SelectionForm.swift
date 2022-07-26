//
//  SelectionForm.swift
//  Amore
//
//  Created by Kshitiz Sharma on 7/25/22.
//

import SwiftUI

struct SelectionForm: View {
    
    @Binding var selection: String?
    @State var formName: String
    @State var selectionsList: [String]
    
    var body: some View {
        
        Section(header: Text(formName)) {
            Picker("Choose \(formName)", selection: $selection) {
                    ForEach(selectionsList, id: \.self) {
                        Text($0)
                    }
                }
            }
    }
}

struct SelectionForm_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SelectionForm(selection:Binding.constant("Red"),
                          formName:"Test",
                          selectionsList:["Red","Yellow","Blue"])
        }
    }
}
