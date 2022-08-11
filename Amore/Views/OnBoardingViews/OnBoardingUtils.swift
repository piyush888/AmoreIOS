//
//  OnBoardingUtils.swift
//  Amore
//
//  Created by Kshitiz Sharma on 8/8/22.
//

import SwiftUI

struct ContinueButtonDesign: View {
    var body: some View {
        ZStack{
            Rectangle()
                .frame(height:45)
                .cornerRadius(10.0)
                .foregroundColor(.accentColor)
            
            Text("Continue")
                .foregroundColor(.white)
        }
    }
}
