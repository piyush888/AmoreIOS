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
        let tempData = fetchDataObj.fetchData(apiToBeUsed:"/fetchprofiles")
        let tempResponse = fetchDataObj.updateCardProfilesWithPhotos(tempData:tempData)
        self.superLikesGivenPhotos = tempResponse.cardsWithPhotos
        self.superLikesGivenPhotos_Dict = tempResponse.cardsDict
    }
        
}
    
