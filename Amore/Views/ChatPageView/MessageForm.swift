//
//  MessageForm.swift
//  Amore
//
//  Created by Piyush Garg on 30/07/22.
//
import SwiftUI

struct MessageForm: View {
    
    @Binding var formHeight: CGFloat
    @State var formPlaceholder: String
    @Binding var formInput: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
            
        ZStack {
            if self.formInput.isEmpty {
                TextEditor(text:$formPlaceholder)
                        .font(.system(.body))
                        .foregroundColor(.gray)
                        .cornerRadius(10)
                        .shadow(color: Color.purple,
                                radius: 1)
            }
            TextEditor(text: $formInput)
                .font(.system(.body))
                .opacity(self.formInput.isEmpty ? 0.25 : 1)
                .cornerRadius(10)
                .shadow(color: self.formInput.isEmpty ? Color.clear : Color.purple,
                        radius: 1)
        }
        .frame(height: formHeight)
    }
}

struct MessageForm_Previews: PreviewProvider {
    static var previews: some View {
        MessageForm(formHeight: Binding.constant(40.0),
                    formPlaceholder: "Enter your message",
                    formInput: Binding.constant(""))
    }
}

