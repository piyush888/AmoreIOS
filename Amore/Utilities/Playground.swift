//
//  Playground.swift
//  Amore
//
//  Created by Kshitiz Sharma on 8/22/22.
//

import SwiftUI

struct Playground: View {
    var body: some View {
        VStack {
            Image("SampleImage1")
                .resizable()
                .scaledToFill()
                .frame(maxHeight:UIScreen.main.bounds.height*0.60)
                .clipped()
        }
    }
}

struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        Playground()
    }
}
