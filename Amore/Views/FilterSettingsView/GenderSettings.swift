//
//  GenderSettings.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/19/21.
//

import SwiftUI

struct GenderSettings: View {
    
    @Binding var genderPreference: String
    @State private var previewIndex = 0
    var previewOptions = ["Male", "Female", "All"]
    
    var body: some View {
        
        ZStack{
            
            CommonContainer()
        
            HStack {
                
                Text("Gender")
                    .font(.subheadline)
                    
                Spacer()
                
                Picker(selection: $previewIndex, label: Text("")) {
                    ForEach(0 ..< previewOptions.count) {
                        Text(self.previewOptions[$0])
                    }
                }
            }.padding(.horizontal,20)
        }
        
    }
}

struct GenderSettings_Previews: PreviewProvider {
    static var previews: some View {
        GenderSettings(genderPreference:Binding.constant("Male"))
    }
}
