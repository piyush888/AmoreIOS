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
        Button {
            showSafari.toggle()
        } label : {
            HStack{
                Text(settingName)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundColor(.primary)
        }
        .fullScreenCover(isPresented: $showSafari, content: {
                SFSafariViewWrapper(url: URL(string: urlToOpen)!)
        })
    }
}


struct SettingFormComponents_Preview: PreviewProvider {
    static var previews: some View {
        SettingFormComponents(settingName:"Cookie Policy",
                              urlToOpen:"https://www.luvamore.com/cookiepolicy")
    }
}


