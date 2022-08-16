//
//  OnBoardingUtils.swift
//  Amore
//
//  Created by Kshitiz Sharma on 8/8/22.
//

import SwiftUI

struct ContinueButtonDesign: View {
    
    @State var buttonText: String
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(height:45)
                .cornerRadius(10.0)
                .foregroundColor(.accentColor)
            
            Text(buttonText)
                .foregroundColor(.white)
        }
    }
}
