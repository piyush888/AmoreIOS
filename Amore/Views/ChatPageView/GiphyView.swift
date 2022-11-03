//
//  GiphyView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/3/22.
//

import SwiftUI

struct GiphyView: View {
    
//    // Gif data
//    @State var gifData : [String] = []
//
    // Gifcontroller
    @Binding var isShowingGifPicker: Bool
    
    var body : some View {
        
//        ZStack {
//            VStack(spacing: 0) {
                // Most of the screen's background becomes a partially transparent
                // black view. Tapping anywhere on it dismisses the Giphy view.
//                Rectangle()
//                    .fill(Color.init(white: 0.0, opacity: 0.5))
//                    .onTapGesture {
//                        withAnimation {
//                            self.isShowingGifPicker = false
//                        }
//
////                        // This little bit covers the bottom area between the GiphyVC and
////                        // the remaining sliver near the screen's bottom safe area
////                        Rectangle()
////                            .fill(Color.init(white: (38.0/255.0)))
////                            .frame(height: 100)
//                    }
                
                GiphyVCRepresentable(onSelectedGif: { _giphyYYImage, width, height in
                    // TODO: do something with _giphyYYImage for your app
                    withAnimation {
                        self.isShowingGifPicker = false
                    }
                }, onShouldDismissGifPicker: {
                    withAnimation {
                        self.isShowingGifPicker = false
                    }
                })
                .padding(.bottom, 20.0)
                .padding(.top, 90.0)
                .transition(.move(edge: .bottom))
//            }
//        }
        
    }
}
