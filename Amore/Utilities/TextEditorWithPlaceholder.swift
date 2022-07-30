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
    @State var textEditorHeight : CGFloat = 40
    @State var maxTextEditorHeight : CGFloat = 100
    @State var minTextHeight: CGFloat = 40
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            Text(text.isEmpty ? placeholder : text)
                .font(.system(.body))
                .padding(.horizontal, 10)
                .foregroundColor(.clear)
                .frame(minHeight: 40)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
                .lineLimit(3)

            MessageForm(formHeight: $minTextHeight, formPlaceholder: placeholder, formInput: $text)
        }
        .onPreferenceChange(ViewHeightKey.self) {
            textEditorHeight = $0
            minTextHeight = min(maxTextEditorHeight, textEditorHeight)
        }
    }
}

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
        TextEditorWithPlaceholder(text: Binding.constant(""), placeholder: "placeholder")
    }
}
