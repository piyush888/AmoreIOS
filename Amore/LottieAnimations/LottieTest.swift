//
//  LottieTest.swift
//  Amore
//
//  Created by Kshitiz Sharma on 7/10/22.
//

import SwiftUI


struct LottieTest: View {
    
    var body: some View {
        VStack {
            LottieView(name: "LikeLottie", loopMode: .playOnce)
                .frame(width: 200,
                       height: 200)
            
            LottieView(name: "DislikeLottie", loopMode: .playOnce)
                .frame(width: 100,
                       height: 100)
        }
    }
}

struct LottieTest_Previews: PreviewProvider {
    static var previews: some View {
        LottieTest()
    }
}
