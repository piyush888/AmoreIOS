//
//  WeakCardProfileModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/10/22.
//

import Foundation
import SDWebImageSwiftUI

// MARK: Weak usage to remove any memory leak in swipe views
/// Memory leaks when array is returned as a strong referece
/// Purpose of this class is to pass the list of Arrays as Weak Reference
class WeakCardProfileModel: ObservableObject {
    
    @Published var cardsInSwipeViewDisplay: [CardProfileWithPhotos]? = []
    var initializeSwipeViewWithCards: Int = 3
    var cardIncrementCount: Int = 0
    var cardsInDeck: [CardProfileWithPhotos]
    
    
    // MARK: -  INIT
    init(cardsInDeck:[CardProfileWithPhotos] = [CardProfileWithPhotos()], cardIncrementCount:Int=0, initializeSwipeViewWithCards:Int=0) {
        print("Initialize WeakCardProfileModel Weak")
        self.cardsInDeck = cardsInDeck
        self.cardIncrementCount = cardIncrementCount
        self.initializeSwipeViewWithCards = initializeSwipeViewWithCards
        self.getCardsToDisplay()
        print("#SwipeView Loaded#")
    }
    
    // MARK: - DEINIT
    deinit {
      print("De-Initialize WeakCardProfileModel Now")
    }

    // MARK: -  Cards to Display in the swipe view
    /// Cards Throttler in Swipe View
    /// Controls the number of cards currently in users swipe view
    func getCardsToDisplay() {
        // Anytime user has 5 cards in the swipe UI
        // Returns only 2 cards in first load
        // After first
        /// You want the first load to be faster so that Swipe loads quickly
        DispatchQueue.global().async { [weak self] in
                let numberOfCardsToBeDisplayed = (self?.initializeSwipeViewWithCards ?? 2) + (self?.cardIncrementCount ?? 0)
                let cardsInDeck = self?.cardsInDeck ?? []
                self?.cardsInSwipeViewDisplay = Array(cardsInDeck.suffix(numberOfCardsToBeDisplayed))
            
                print("# Cards in deck \(self?.cardsInDeck.count ?? 0)")
                print("# Cards displayed \(self?.cardsInSwipeViewDisplay?.count ?? 0)")
          }
    }
    
    // MARK: - Prefetcher Card After Each User Swipe
    /// For every card the user swipes, we prefetch another card
    /// TODO: Depending on the user swipe speed prefetch the next cards in deck
    func prefetchNextCardPhotos() {
        /// Check for the number of cards currently in display
        let numberOfCardsInDisplay = self.cardsInSwipeViewDisplay?.count ?? 0
        /// Get the card index you want to prefetch the images for, i.e. the next cared not being displayed yet
        let cardIndex = numberOfCardsInDisplay + 1
        /// Check if index is not out of bound
        if cardIndex < self.cardsInDeck.count {
            let card = cardsInDeck[cardIndex]
            var urls: [URL] = []
            for url in [card.image1?.imageURL, card.image2?.imageURL, card.image3?.imageURL, card.image4?.imageURL, card.image5?.imageURL, card.image6?.imageURL] {
                if url != nil {
                    urls.append(url!)
                }
            }
            SDWebImagePrefetcher.shared.prefetchURLs(urls) { completed, total in
                // Progress Block
            } completed: { completed, skipped in
                // On Complete Block
                print("Images prefetched for user \(card.id)")
            }
        } else {
            // TODO: No more cards left to prefetch, raise an Alert
            print("Don't have sufficient number of cards in deck")
        }
        
        
    }
    
    // MARK: Delete SDWebImages cache after swipe
    /// Call this function to deallocate memory and NSData cache from the device for that profile
    func deleteCardImages(singleProfile:CardProfileWithPhotos) {
        if let imageURL = singleProfile.image1?.imageURL {
            SDImageCache.shared.removeImage(forKey: imageURL.absoluteString)
        }
        if let imageURL = singleProfile.image2?.imageURL {
            SDImageCache.shared.removeImage(forKey: imageURL.absoluteString)
        }
        if let imageURL = singleProfile.image3?.imageURL {
            SDImageCache.shared.removeImage(forKey: imageURL.absoluteString)
        }
        if let imageURL = singleProfile.image4?.imageURL {
            SDImageCache.shared.removeImage(forKey: imageURL.absoluteString)
        }
        if let imageURL = singleProfile.image5?.imageURL {
            SDImageCache.shared.removeImage(forKey: imageURL.absoluteString)
        }
        if let imageURL = singleProfile.image6?.imageURL {
            SDImageCache.shared.removeImage(forKey: imageURL.absoluteString)
        }
    }
    
}
