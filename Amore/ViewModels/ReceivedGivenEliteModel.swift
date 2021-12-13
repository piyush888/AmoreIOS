//
//  ReceivedGivenEliteModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/10/21.
//

import Foundation


class ReceivedGivenEliteModel: ObservableObject {
    
    @Published var superLikesGivenPhotos = [CardProfileWithPhotos]()
    @Published var superLikesGivenPhotos_Dict: [String: CardProfileWithPhotos] = [:]
    @Published var fetchDataObj = FetchDataModel()
    
    func getLikesGivenData() {
        self.fetchDataObj.fetchData(apiToBeUsed: "/fetchlikesgiven") {
            print("Error with fetching, Likes Given Data")
        } onSuccess: { tempData in
            let tempResponse = self.fetchDataObj.updateCardProfilesWithPhotos(tempData:tempData)
            self.superLikesGivenPhotos = tempResponse.cardsWithPhotos
            self.superLikesGivenPhotos_Dict = tempResponse.cardsDict
        }

        
    }
        
}
    
