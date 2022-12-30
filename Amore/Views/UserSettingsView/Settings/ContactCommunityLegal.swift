//
//  ContactCommunityLegal.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/28/21.
//

import SwiftUI


struct SettingFormComponents: View {
    
    @State private var showSafari: Bool = false
    @State var settingName: String = ""
    @State var urlToOpen: String = ""
    
    var body: some View {
        HStack {
            Text(settingName)
            Spacer()
            Image(systemName: "chevron.right")
        }.onTapGesture {
            showSafari.toggle()
        }.fullScreenCover(isPresented: $showSafari, content: {
                SFSafariViewWrapper(url: URL(string: urlToOpen)!)
        })
    
    }
}
