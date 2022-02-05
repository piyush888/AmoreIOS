//
//  MainMessagesViewModel.swift
//  Amore
//
//  Created by Piyush Garg on 03/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SDWebImageSwiftUI

class MainMessagesViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var errorMessage = ""
    @Published var fromUser: ChatUser?

    init() {
        fetchCurrentUser()
    }

    private func fetchCurrentUser() {

        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }

        db.collection("Profiles").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }

            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return

            }
            let id = Auth.auth().currentUser?.uid
            let fname = data["firstName"] as? String ?? ""
            let lname = data["lastName"] as? String ?? ""
            let profileImage = data["image1"] as? ProfileImage ?? ProfileImage()
            self.fromUser = ChatUser(id: id, firstName: fname, lastName: lname, image1: profileImage)
        }
    }

}
