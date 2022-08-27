//
//  SampleGUI.swift
//  Amore
//
//  Created by Kshitiz Sharma on 8/26/22.
//

import SwiftUI

struct SampleGUI: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("gold-star"))
                .frame(width: 40, height: 40)
            
            Text("\(2)")
                .foregroundColor(Color.white)
                .bold()
                .font(.headline)
        }
    }
}

struct SampleGUI_Previews: PreviewProvider {
    static var previews: some View {
        SampleGUI()
    }
}
