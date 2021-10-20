//
//  CommonContainer.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/19/21.
//

import SwiftUI

struct CommonContainer: View {
    var body: some View {
        
        Rectangle()
            .cornerRadius(5.0)
            .frame(height:40)
            .foregroundColor(.white)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary, lineWidth: 0.2))
    }
}

struct CommonContainer_Previews: PreviewProvider {
    static var previews: some View {
        CommonContainer()
    }
}
