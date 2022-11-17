//
//  CustomGiphyView.swift
//  Amore
//
//  Created by Piyush Garg on 09/11/22.
//

import SwiftUI
import GiphyUISDK

struct CustomGiphyView: UIViewRepresentable {
    
    @State var giphyMediaId: String
    
    func makeUIView(context: Context) -> GPHMediaView {
        // Return GPHMediaView instance
        Giphy.configure(apiKey: "KBFvAPfuBMVktOiaV4bJrSRrNFwSPi5z")
        let giphy = GiphyViewController()
        var view = GPHMediaView()
        
        GiphyCore.shared.gifByID(giphyMediaId) { (response, error) in
            if let media = response?.data {
                DispatchQueue.main.async {
                    view.media = media
                }
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: GPHMediaView, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
    
}

