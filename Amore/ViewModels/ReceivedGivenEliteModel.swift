//
//  ReceivedGivenEliteModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/10/21.
//

import Foundation
import SwiftUI


class ReceivedGivenEliteModel: ObservableObject {
    
    // superlikes given
    @Published var superLikesGivenPhotos = [CardProfileWithPhotos]()
    @Published var superLikesGivenPhotos_Dict: [String: CardProfileWithPhotos] = [:]
    
    // superlikes received
    @Published var superLikesReceivedPhotos = [CardProfileWithPhotos]()
    @Published var superLikesReceivedPhotos_Dict: [String: CardProfileWithPhotos] = [:]
    
    // elites
    @Published var elitesReceivedPhotos = [CardProfileWithPhotos]()
    @Published var elitesReceivedPhotos_Dict: [String: CardProfileWithPhotos] = [:]
    
    @Published var fetchDataObj = FetchDataModel()
    
    func getLikesGivenData() {
        self.fetchDataObj.fetchData(apiToBeUsed: "/fetchlikesgiven",requestBody:["DataStatus": "No Data"]) {
            print("Error while fetching /fetchlikesgiven")
        } onSuccess: { tempData in
            let tempResponse = self.fetchDataObj.updateCardProfilesWithPhotos(tempData:tempData)
            self.superLikesGivenPhotos = tempResponse.cardsWithPhotos
            self.superLikesGivenPhotos_Dict = tempResponse.cardsDict
        }
    }
    
    func getLikesReceivedData() {
        self.fetchDataObj.fetchData(apiToBeUsed: "/fetchlikesreceived",requestBody:["DataStatus": "No Data"]) {
            print("Error while fetching /fetchlikesreceived")
        } onSuccess: { tempData in
            let tempResponse = self.fetchDataObj.updateCardProfilesWithPhotos(tempData:tempData)
            self.superLikesReceivedPhotos = tempResponse.cardsWithPhotos
            self.superLikesReceivedPhotos_Dict = tempResponse.cardsDict
        }
    }
    
    func elitesReceivedData() {
        self.fetchDataObj.fetchData(apiToBeUsed: "/fetchelites",requestBody:["DataStatus": "No Data"]) {
            print("Error while fetching /fetchelites")
        } onSuccess: { tempData in
            let tempResponse = self.fetchDataObj.updateCardProfilesWithPhotos(tempData:tempData)
            self.elitesReceivedPhotos = tempResponse.cardsWithPhotos
            self.elitesReceivedPhotos_Dict = tempResponse.cardsDict
        }
    }
    
    func getProfile(profileId:String, selectedTab:TopPicksLikesView) -> Binding<CardProfileWithPhotos> {
        switch selectedTab {
            case .likesReceived:
                return Binding {
                    self.superLikesReceivedPhotos_Dict[profileId] ?? CardProfileWithPhotos()
                } set: { newCard in
                    self.superLikesReceivedPhotos_Dict[profileId] = newCard
                }
            
            case .superLikesGive:
                return Binding {
                    self.superLikesGivenPhotos_Dict[profileId] ?? CardProfileWithPhotos()
                } set: { newCard in
                    self.superLikesGivenPhotos_Dict[profileId] = newCard
                }

            case .elitePicks:
                return Binding {
                    self.elitesReceivedPhotos_Dict[profileId] ?? CardProfileWithPhotos()
                } set: { newCard in
                    self.elitesReceivedPhotos_Dict[profileId] = newCard
                }
            
        }
    }
    
    
    
        
}
    
