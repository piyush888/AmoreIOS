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
    
    var body: some View {
    
        VStack {
            
            HStack {
                Text(formHeadLine)
                    .font(.headline)
                    .frame(alignment: .leading)
                Spacer()
            }
            
            // If the size of form field is more than 50, then we need to make use of TextField instead of TextEditor
            if formHeight > 50.0 {
                TextEditor(text: $formInput.bound)
                    .frame(height: formHeight)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
            } else {
                TextField("", text: $formInput.bound)
                    .frame(height: formHeight)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
            }
                
//            HStack {
//                Spacer()
//                Text("\(formInput.text.count) / \(formInput.characterLimit)")
//                    .font(.caption2)
//                    .multilineTextAlignment(.trailing)
//            }
        }
        .padding(.top,10)
        
    }
}
