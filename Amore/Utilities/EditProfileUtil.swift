//
//  EditProfileUtil.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/25/21.
//

import SwiftUI

class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int

    init(limit: Int = 5){
        characterLimit = limit
    }
}


struct EditCardForm: View {
    
    @State var formHeight: CGFloat
    @State var formHeadLine: String
    @Binding var formInput: String?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Section(header: Text(formHeadLine)) {
            TextEditor(text: $formInput.bound)
                .frame(height: formHeight)
        }
    }
}


struct EditCardForm_Previews: PreviewProvider {
    static var previews: some View {
        List {
            EditCardForm(formHeight: 100.0,
                         formHeadLine: "Name",
                         formInput: Binding.constant(""))
                .foregroundColor(Color.black)
                .padding()
            
            EditCardForm(formHeight: 40.0,
                         formHeadLine: "About",
                         formInput: Binding.constant(""))
                .foregroundColor(Color.black)
                .padding()
        }
    }
}
