//
//  WriteReview.swift
//  Amore
//
//  Created by Kshitiz Sharma on 8/22/22.
//

import Foundation
import StoreKit


class AppReview: ObservableObject {
    
    func writeReview() {
      let productURL = URL(string: "https://itunes.apple.com/app/id958625272")!
      var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
      components?.queryItems = [
        URLQueryItem(name: "action", value: "write-review")
      ]
     guard let writeReviewURL = components?.url else {
        return
      }
     UIApplication.shared.open(writeReviewURL)
    }

}
