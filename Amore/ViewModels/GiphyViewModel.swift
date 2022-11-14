//
//  GiphyViewModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/2/22.
//

import Foundation
import SwiftUI
import UIKit
import GiphyUISDK

struct GiphyVCRepresentable : UIViewControllerRepresentable {
    
    public typealias UIViewControllerType = GiphyViewController
    
    @Binding var giphyURL: String
    @Binding var giphyId: String
    @Binding var isShowingGifPicker: Bool
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent:self)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<GiphyVCRepresentable>) -> GiphyViewController {
        Giphy.configure(apiKey: "KBFvAPfuBMVktOiaV4bJrSRrNFwSPi5z")
        let giphy = GiphyViewController()
        giphy.delegate = context.coordinator
        giphy.showConfirmationScreen = true
        giphy.mediaTypeConfig = [.gifs, .stickers, .recents]
        giphy.theme = CustomGiphyTheme(type:.automatic)
        GiphyViewController.trayHeightMultiplier = 1.05 // This causes the tray to start at the screen's full height
        GPHCache.shared.cache.diskCapacity = 300 * 1000 * 1000
        GPHCache.shared.cache.memoryCapacity = 100 * 1000 * 1000
        return giphy
    }
    
    public func updateUIViewController(_ giphyViewController: GiphyViewController, context: UIViewControllerRepresentableContext<GiphyVCRepresentable>) {
        // TODO:
    }
    
    class Coordinator: NSObject, GiphyDelegate {
        let parent: GiphyVCRepresentable
        
        init(parent: GiphyVCRepresentable) {
            self.parent = parent
        }
        
        func didSearch(for term: String) {
            print("GiphyDelegate: the user made searched for: ", term)
        }
        
        func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
            self.parent.giphyURL = media.url(rendition: giphyViewController.renditionType, fileType: .gif) ?? ""
            self.parent.giphyId = media.id
            self.parent.isShowingGifPicker = false
        }
        
        func didDismiss(controller: GiphyViewController?) {
            self.parent.isShowingGifPicker = false
        }
    }
}

public class CustomGiphyTheme: GPHTheme {
    @Environment(\.colorScheme) var colorScheme
    
    public override init() {
        super.init()
        self.type = .darkBlur
    }
    
    public override var textFieldFont: UIFont? {
        return UIFont(name: "Futura-Medium", size: 15)
    }

    public override var textColor: UIColor {
        return colorScheme == .dark ? .white: .black
    }
}


struct GipyCustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width:35, height:35))
        return Path(path.cgPath)
    }
    
}
