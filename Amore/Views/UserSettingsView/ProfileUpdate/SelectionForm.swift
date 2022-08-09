//
//  SelectionForm.swift
//  Amore
//
//  Created by Kshitiz Sharma on 7/25/22.
//

import SwiftUI

struct SelectionForm: View {
    
    @Binding var selection: String
    @State private var searchTerm: String = ""
    @State var formName: String
    @State var selectionsList: [String]
    @Binding var formUpdated: Bool
    
    
    var filteredSelectionList: [String] {
        self.selectionsList.filter {
            searchTerm.isEmpty ? true : $0.lowercased().contains(searchTerm.lowercased())
        }
    }
    
    var body: some View {
        
         Picker("\(formName)", selection: $selection) {
                SearchBar(text: $searchTerm, placeholder: "Search \(formName)")
                ForEach(filteredSelectionList, id: \.self) {
                    Text($0).tag($0)
                }
                .navigationBarTitle("\(formName)") // for picker navigation title
                .navigationBarTitleDisplayMode(.inline)
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

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var placeholder: String

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator

        searchBar.placeholder = placeholder
        searchBar.autocapitalizationType = .none
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
}
