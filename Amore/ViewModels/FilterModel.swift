//
//  FilterModel.swift
//  Amore
//
//  Created by Piyush Garg on 22/11/21.
//

import Foundation
import Firebase
import CoreLocation

class FilterModel: ObservableObject {
    @Published var filterData = Filters()
    var oldFilterData = Filters()
    let db = Firestore.firestore()
    @Published var filterDataFetched = false

    func createFilter() -> Bool {
        // Firestore Write
        let collectionRef = db.collection("FilterAndLocation")
        if let id = oldFilterData.id {
            do {
                let newDocReference = try collectionRef.document(id).setData(from: oldFilterData)
                print("filterData stored in firestore with new document reference: \(newDocReference)")
                self.filterData = self.oldFilterData
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
    
    func getFilter() {
        // Example function, Firestore Read Implementation
        self.filterDataFetched = false
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
                            self.oldFilterData = try document.data(as: Filters.self) ?? Filters()
                            self.filterData = self.oldFilterData
//                            print("Location: Filter and Location data Refresh done...")
                            self.filterDataFetched = true
                        }
                        catch {
                            print(error)
                            self.filterDataFetched = true
                        }
                    }
                }
//                self.filterDataFetched = true
            }
        }
        
    }
    
    func updateFilter() {
        if let profileId = Auth.auth().currentUser?.uid {
            if filterData != oldFilterData {
                do {
//                    print("Location: Updating FilterData on Firestore...")
                    try db.collection("FilterAndLocation").document(profileId).setData(from: filterData)
                    print(filterData)
                    oldFilterData = filterData
                }
                catch {
//                    print("Location: Error while updating FilterData in Firestore: ")
                    print(error.localizedDescription)
                }
            }
            else {
//                print("Location: No change in Filter Data...")
            }
        }
    }
    
}
