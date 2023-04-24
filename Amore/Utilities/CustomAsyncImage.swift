//
//  CustomAsyncImage.swift
//  Amore
//
//  Created by Piyush Garg on 20/04/23.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct CustomAsyncImage<Placeholder: View>: View {
    @StateObject private var imageLoader: ImageLoader
    private let placeholder: Placeholder
    
    init(url: URL?, @ViewBuilder placeholder: () -> Placeholder) {
        self._imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder()
    }
    
    var body: some View {
        Group {
            switch imageLoader.image {
            case nil:
                placeholder
            default:
                Image(uiImage: imageLoader.image!)
                    .resizable()
                    .scaledToFill()
            }
        }
        .onAppear {
            imageLoader.load()
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private var url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    func load() {
        guard let url = url else { return }
        SDWebImageManager.shared.loadImage(with: url, options: [.scaleDownLargeImages,.continueInBackground, .retryFailed], progress: nil) { [weak self] image, data, error, cacheType, finished, durl in
            if let err = error {
                print(err)
                return
            }
            guard let image = image else {
                // No image handle this error
                print("No Image fetched for \(error), CacheType:\(cacheType)")
                print(error)
                return
            }
            self?.image = image
        }
    }
    
}
