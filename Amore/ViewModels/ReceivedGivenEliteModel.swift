//
//  ReceivedGivenEliteModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/10/21.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI


class ReceivedGivenEliteModel: ObservableObject {
    
    // likes given
    @Published var likesGivenPhotos = [CardProfileWithPhotos]()
    @Published var likesGivenPhotos_Dict: [String: CardProfileWithPhotos] = [:]
    
    // superlikes given
    @Published var superLikesGivenPhotos = [CardProfileWithPhotos]()
    @Published var superLikesGivenPhotos_Dict: [String: CardProfileWithPhotos] = [:]
    
    // superlikes received
    @Published var superLikesReceivedPhotos = [CardProfileWithPhotos]()
    @Published var superLikesReceivedPhotos_Dict: [String: CardProfileWithPhotos] = [:]
    
    // elites
    @Published var elitesPhotos = [CardProfileWithPhotos]()
    @Published var elitesPhotos_Dict: [String: CardProfileWithPhotos] = [:]
    
    // matches
    @Published var matchesPhotos = [CardProfileWithPhotos]()
    @Published var matchesPhotos_Dict: [String: CardProfileWithPhotos] = [:]
    
    
    @Published var fetchDataObj = FetchDataModel()
    
    func getLikesGivenData() {
        self.fetchDataObj.fetchData(apiToBeUsed: "/commonfetchprofiles",requestBody:["fromCollection": "likesGiven", "noOfLastRecords": 20]) {
            print("Error while fetching /likesGiven")
        } onSuccess: { tempData in
            _ = tempData.map{ card in
                ImageService.prefetchNextCardPhotos(card: card)
            }
            let tempResponse = self.fetchDataObj.updateCardProfilesWithPhotos(tempData:tempData)
            self.likesGivenPhotos = tempResponse.cardsWithPhotos
            self.likesGivenPhotos_Dict = tempResponse.cardsDict
        }
    }
    
    func getSuperLikesGivenData() {
        self.fetchDataObj.fetchData(apiToBeUsed: "/commonfetchprofiles",requestBody:["fromCollection": "superLikesGiven", "noOfLastRecords": 20]) {
            print("Error while fetching /superLikesGiven")
        } onSuccess: { tempData in
            _ = tempData.map{ card in
                ImageService.prefetchNextCardPhotos(card: card)
            }
            let tempResponse = self.fetchDataObj.updateCardProfilesWithPhotos(tempData:tempData)
            self.superLikesGivenPhotos = tempResponse.cardsWithPhotos
            self.superLikesGivenPhotos_Dict = tempResponse.cardsDict
        }
    }
    
    func getSuperLikesReceivedData() {
        self.fetchDataObj.fetchData(apiToBeUsed: "/commonfetchprofiles",requestBody:["fromCollection": "superLikesReceived", "noOfLastRecords": 20]) {
            print("Error while fetching /superLikesReceived")
        } onSuccess: { tempData in
            _ = tempData.map{ card in
                ImageService.prefetchNextCardPhotos(card: card)
            }
            let tempResponse = self.fetchDataObj.updateCardProfilesWithPhotos(tempData:tempData)
            self.superLikesReceivedPhotos = tempResponse.cardsWithPhotos
            self.superLikesReceivedPhotos_Dict = tempResponse.cardsDict
        }
    }
    
    func elitesData(profilesAlreadySwiped: [CardProfileWithPhotos]) {
        self.fetchDataObj.fetchData(apiToBeUsed: "/commonfetchprofiles",requestBody:["fromCollection": "elitePicks", "noOfLastRecords": 10, "profilesAlreadySwiped": profilesAlreadySwiped.map({ profile in
            return profile.id
        })]) {
            print("Error while fetching elitePicks")
        } onSuccess: { tempData in
            _ = tempData.map{ card in
                ImageService.prefetchNextCardPhotos(card: card)
            }
            let tempResponse = self.fetchDataObj.updateCardProfilesWithPhotos(tempData:tempData)
            self.elitesPhotos = tempResponse.cardsWithPhotos
            self.elitesPhotos_Dict = tempResponse.cardsDict
        }
    }
    
    func loadMatches() {
        self.fetchDataObj.fetchData(apiToBeUsed: "/loadmatchesunmatches",requestBody:["fromCollection": "Match"]) {
            print("Error while loading matches profiles")
        } onSuccess: { tempData in
            _ = tempData.map{ card in
                ImageService.prefetchNextCardPhotos(card: card)
            }
            let tempResponse = self.fetchDataObj.updateCardProfilesWithPhotos(tempData:tempData)
            self.matchesPhotos = tempResponse.cardsWithPhotos
            self.matchesPhotos_Dict = tempResponse.cardsDict
        }
    }
    
    func getProfile(profileId:String, selectedTab:TopPicksLikesView, selectedTabSubView:TopPicksLikesSubView) -> Binding<CardProfileWithPhotos> {
        switch selectedTab {
            case .likesReceived:
                return Binding {
                    self.superLikesReceivedPhotos_Dict[profileId] ?? CardProfileWithPhotos()
                } set: { newCard in
                    self.superLikesReceivedPhotos_Dict[profileId] = newCard
                }
            case .superLikesAndLikesGiven:
                // Eihther the profile will be in self.likesGivenPhotos_Dict or superLikesGivenPhotos_Dict
                if self.likesGivenPhotos_Dict[profileId] != nil {
                    return Binding {
                        self.likesGivenPhotos_Dict[profileId] ?? CardProfileWithPhotos()
                    } set: { newCard in
                        self.likesGivenPhotos_Dict[profileId] = newCard
                    }
                } else {
                    return Binding {
                        self.superLikesGivenPhotos_Dict[profileId] ?? CardProfileWithPhotos()
                    } set: { newCard in
                        self.superLikesGivenPhotos_Dict[profileId] = newCard
                    }
                }
                
            case .elitePicks:
                return Binding {
                    self.elitesPhotos_Dict[profileId] ?? CardProfileWithPhotos()
                } set: { newCard in
                    self.elitesPhotos_Dict[profileId] = newCard
                }
        }
    }
    
    func removeProfileFromArray(profileId:String, selectedTab:TopPicksLikesView) {
        switch selectedTab {
            case .likesReceived:
                self.superLikesReceivedPhotos.removeAll { $0.id == profileId }
                self.superLikesReceivedPhotos_Dict.removeValue(forKey: profileId)
            case .superLikesAndLikesGiven:
//                // transfer from likes to superlikes..
//                // to do make similar replacement on backend
//                self.superLikesGivenPhotos.insert(self.likesGivenPhotos_Dict[profileId] ?? CardProfileWithPhotos(),at:0)
//                self.superLikesGivenPhotos_Dict[profileId] = self.likesGivenPhotos_Dict[profileId]
                // You only need to remove from Likes Given and move it to SuperLikes Given
                self.likesGivenPhotos.removeAll { $0.id == profileId }
                self.likesGivenPhotos_Dict.removeValue(forKey: profileId)
            case .elitePicks:
                self.elitesPhotos.removeAll { $0.id == profileId }
                self.elitesPhotos_Dict.removeValue(forKey: profileId)
            }
    }
    
    func addProfileToArray(profileId: String, selectedTab:TopPicksLikesView, swipeInfo: AllCardsView.LikeDislike) {
        switch selectedTab {
            case .superLikesAndLikesGiven:
                // transfer from likes to superlikes..
                // to do make similar replacement on backend
                self.superLikesGivenPhotos.insert(self.likesGivenPhotos_Dict[profileId] ?? CardProfileWithPhotos(),at:0)
                self.superLikesGivenPhotos_Dict[profileId] = self.likesGivenPhotos_Dict[profileId]
            case .likesReceived:
                guard let profileCard = superLikesReceivedPhotos_Dict[profileId] else {return}
                if swipeInfo == .like {
                    likesGivenPhotos.insert(profileCard, at: 0)
                    likesGivenPhotos_Dict[profileId] = profileCard
                }
                else if swipeInfo == .superlike {
                    superLikesGivenPhotos.insert(profileCard, at: 0)
                    superLikesGivenPhotos_Dict[profileId] = profileCard
                }
            case .elitePicks:
                guard let profileCard = elitesPhotos_Dict[profileId] else {return}
                if swipeInfo == .like {
                    likesGivenPhotos.insert(profileCard, at: 0)
                    likesGivenPhotos_Dict[profileId] = profileCard
                }
                else if swipeInfo == .superlike {
                    superLikesGivenPhotos.insert(profileCard, at: 0)
                    superLikesGivenPhotos_Dict[profileId] = profileCard
                }
            }
    }
    
    func addProfileToArrayFromSwipeView(profileCard: CardProfileWithPhotos, swipeInfo: AllCardsView.LikeDislike) {
        guard let id = profileCard.id else {
            return
        }
        if swipeInfo == .like {
            likesGivenPhotos.insert(profileCard, at: 0)
            likesGivenPhotos_Dict[id] = profileCard
        }
        else if swipeInfo == .superlike {
            superLikesGivenPhotos.insert(profileCard, at: 0)
            superLikesGivenPhotos_Dict[id] = profileCard
        }
    }
    
    func rewindAction(swipedUserId: String?) {
        if let swipedUserId = swipedUserId {
            if likesGivenPhotos_Dict[swipedUserId] != nil {
                likesGivenPhotos.removeAll { $0.id == swipedUserId }
                likesGivenPhotos_Dict.removeValue(forKey: swipedUserId)
            }
            else if superLikesGivenPhotos_Dict[swipedUserId] != nil {
                superLikesGivenPhotos.removeAll { $0.id == swipedUserId }
                superLikesGivenPhotos_Dict.removeValue(forKey: swipedUserId)
            }
        }
    }
        
}
    
