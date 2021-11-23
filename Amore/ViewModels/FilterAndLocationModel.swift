//
//  FilterAndLocationModel.swift
//  Amore
//
//  Created by Piyush Garg on 22/11/21.
//

import Foundation
import Firebase

class FilterAndLocationModel: ObservableObject {
    @Published var filterAndLocationData = FiltersAndLocation()
    var oldFilterAndLocationData = FiltersAndLocation()
    let db = Firestore.firestore()
    @Published var filterAndLocationDataFetched = false
    
    func createFilterAndLocation() -> Bool {
        // Firestore Write
        let collectionRef = db.collection("FilterAndLocation")
        if let id = oldFilterAndLocationData.id {
            do {
                let newDocReference = try collectionRef.document(id).setData(from: oldFilterAndLocationData)
                print("filterAndLocationData stored in firestore with new document reference: \(newDocReference)")
                self.filterAndLocationData = self.oldFilterAndLocationData
                return true
            }
            catch let error {
                print("Error writing document to Firestore: \(error)")
            }
        }
        else{
            print("No user uid")
        }
        return false
    }
    
    func getFilterAndLocation() {
        // Example function, Firestore Read Implementation
        self.filterAndLocationDataFetched = false
        let collectionRef = db.collection("FilterAndLocation")
        if let documentId = Auth.auth().currentUser?.uid {
            let docRef = collectionRef.document(documentId)
            // Get Data from Firestore. Network Action -- Async Behaviour at this point
            docRef.getDocument { [self] document, error in
                if let error = error as NSError? {
                    print("Error getting document: \(error.localizedDescription)")
                }
                else {
                    if let document = document {
                        do {
                            // Get User Profile from Firestore.
                            self.oldFilterAndLocationData = try document.data(as: FiltersAndLocation.self) ?? FiltersAndLocation()
                            self.filterAndLocationData = self.oldFilterAndLocationData
                            print("Filter and Location data Refresh done...")
                            self.filterAndLocationDataFetched = true
                        }
                        catch {
                            print(error)
                        }
                    }
                }
                self.filterAndLocationDataFetched = true
            }
        }
        
    }
    
    func updateFilterAndLocation() {
        if let profileId = Auth.auth().currentUser?.uid {
            if filterAndLocationData != oldFilterAndLocationData {
                do {
                    print("Updating FilterAndLocationData on Firestore...")
                    try db.collection("FilterAndLocation").document(profileId).setData(from: filterAndLocationData)
                    print(filterAndLocationData)
                    oldFilterAndLocationData = filterAndLocationData
                }
                catch {
                    print("Error while updating FilterAndLocationData in Firestore: ")
                    print(error.localizedDescription)
                }
            }
            else {
                print("No change in FilterAndLocation Data...")
            }
        }
    }
}
