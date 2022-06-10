//
//  TextEditorWithPlaceholder.swift
//  Amore
//
//  Created by Piyush Garg on 09/06/22.
//

import SwiftUI

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    @State var placeholder: String = "Placeholder"
    @State var textEditorHeight : CGFloat = 10
    @State var maxTextEditorHeight : CGFloat = 100
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            Text(text.isEmpty ? placeholder : text)
                .font(.system(.body))
                .foregroundColor(text.isEmpty ? .gray : .clear)
                .padding(14)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
                .frame(minHeight: textEditorHeight, idealHeight: textEditorHeight, maxHeight: maxTextEditorHeight)
            
            TextEditor(text: $text)
                .font(.system(.body))
                .opacity(text.isEmpty ? 0.5 : 1)
                .frame(height: min(maxTextEditorHeight, textEditorHeight))
                .cornerRadius(10.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
        .onPreferenceChange(ViewHeightKey.self) {
            textEditorHeight = $0
        }
        
    }
}

//struct TextEditorWithPlaceholder: View {
//    @State var placeholder: String = "Placeholder"
//    @Binding var text: String
//
//    init(text: Binding<String>, placeholder: String) {
//        self.placeholder = placeholder
//        self._text = text
//    }
//
//    var body: some View {
//        TextEditor(text: $text)
//            .background(
//                HStack(alignment: .top) {
//                    text.isBlank ? Text(placeholder) : Text("")
//                    Spacer()
//                }
//                .foregroundColor(Color.primary.opacity(0.25))
//                .padding(EdgeInsets(top: 0, leading: 4, bottom: 7, trailing: 0))
//            )
//    }
//}

extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}



struct TextEditorWithPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        //        TextEditorWithPlaceholder("placeholder", text: Binding.constant("text"))
        TextEditorWithPlaceholder(text: Binding.constant("text"), placeholder: "placeholder")
    }
}
