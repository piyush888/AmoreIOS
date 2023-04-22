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
    @State var maxChars: Int// maximum number of characters allowed
        
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
            ZStack {
                if self.formInput.bound.isEmpty {
                    TextEditor(text:$formHeadLine)
                        .frame(minHeight: formHeight)
                        .foregroundColor(.gray)
                        .disabled(true)
                }
                TextEditor(text: $formInput.bound)
                    .frame(minHeight: formHeight, maxHeight:.infinity)
                    .cornerRadius(6)
                    .onChange(of: formInput.bound) { newValue in
                        if newValue.count > maxChars { // limit number of characters
                            formInput?.removeLast()
                        }
                    }
            }
    }
}

struct EditCardForm_Previews: PreviewProvider {
    static var previews: some View {
        
        Form {
            Section(header: Text("Headline")) {
                EditCardForm(formHeight: 40.0,
                             formHeadLine: "Headline",
                             formInput:Binding.constant(""),
                             maxChars:200)
            }
            .navigationBarTitle("Headline")
            .navigationBarTitleDisplayMode(.inline)
            
            Section(header: Text("Description")) {
                List {
                    EditCardForm(formHeight: 100.0,
                                 formHeadLine: "Name",
                                 formInput: Binding.constant(""),
                                 maxChars:30)
                    .foregroundColor(Color.black)
                    
                    EditCardForm(formHeight: 40.0,
                                 formHeadLine: "About",
                                 formInput: Binding.constant(""),
                                 maxChars:30)
                    .foregroundColor(Color.black)
                    
                }
            }
        }
    }
}
