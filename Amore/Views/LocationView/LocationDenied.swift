//
//  LocationDenied.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/2/21.
//

import SwiftUI

struct LocationDenied: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Group {
                Text("Oops !! In order to use Amore you need to enable your location")
                Text("Go to Settings > Amore > Location > Enable Locations While Using the App")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .padding(.top,20)
            }
            .padding(.horizontal,30)
            
            Spacer()
            Button{
                // TODO
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            } label : {
                ContinueButtonDesign(buttonText:"Open Settings")
            }
            
        }
        .navigationBarHidden(true)
        
    }
}

struct LocationDenied_Previews: PreviewProvider {
    static var previews: some View {
        LocationDenied()
    }
}
