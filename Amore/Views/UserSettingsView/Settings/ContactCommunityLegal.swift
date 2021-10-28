//
//  ContactCommunityLegal.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/28/21.
//

import SwiftUI

struct ContactCommunityLegal: View {
    
    @State var width: CGFloat = 0.0
    
    var body: some View {
        
        Form {
            
            SettingFormComponents(settingName:"Help & Support",
                                  urlToOpen:"http://aidronesoftware.com")
            
            SettingFormComponents(settingName:"Community Guidelines",
                                  urlToOpen:"http://aidronesoftware.com")
            
            SettingFormComponents(settingName:"Safety Tips",
                                  urlToOpen:"http://aidronesoftware.com")
            
            SettingFormComponents(settingName:"Safety Center",
                                  urlToOpen:"http://aidronesoftware.com")
            
            SettingFormComponents(settingName:"Privacy Policy",
                                  urlToOpen:"http://aidronesoftware.com")
            
            SettingFormComponents(settingName:"Terms of Service",
                                  urlToOpen:"http://aidronesoftware.com")
            
            SettingFormComponents(settingName:"License",
                                  urlToOpen:"http://aidronesoftware.com")
            
            SettingFormComponents(settingName:"Privacy Preference",
                                  urlToOpen:"http://aidronesoftware.com")
            
        }
        .cornerRadius(15)
    }
}


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

struct ContactCommunityLegal_Previews: PreviewProvider {
    static var previews: some View {
        ContactCommunityLegal(width:400.0)
    }
}
