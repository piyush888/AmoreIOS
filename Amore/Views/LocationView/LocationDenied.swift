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
            
            Text("Oops")
                .font(.BoardingTitle)
            
            Text("In order to use Amore you need to enable your location")
                .font(.BoardingSubHeading)
                .padding(.horizontal,60)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40)
            
            Text("Go to Settings > Amore > Location > Enable Locations While Using the App")
                .font(.BoardingSubHeading)
                .padding(.horizontal,60)
                .multilineTextAlignment(.center)
                .padding(.bottom, 60)
            
            Button{
                // TODO
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            } label : {
                ZStack{
                    Rectangle()
                        .cornerRadius(5.0)
                        .frame(height:45)
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.pink, lineWidth: 1))
                        .padding(.horizontal,70)
                        
                    Text("Open Settings")
                        .foregroundColor(.pink)
                        .bold()
                        .font(.BoardingButton)
                }
            }
            
            Spacer()
            
        }
        
    }
}

struct LocationDenied_Previews: PreviewProvider {
    static var previews: some View {
        LocationDenied()
    }
}
