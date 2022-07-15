//
//  customNavBar.swift
//  Amore
//
//  Created by Piyush Garg on 04/02/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct customNavBar: View {
    
    @Binding var toUser: ChatUser
    @Binding var presentProfileCard: Bool
    @EnvironmentObject var mainMessagesModel: MainMessagesViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        Button {
            /**
             Show Profile Card
             */
            if let uid = toUser.id {
                if (mainMessagesModel.allChatPhotos_Dict[uid] != nil) {
                    print("Chat: Present Profile Card for \(uid): \(presentProfileCard)")
                    withAnimation(.spring()){
                        presentProfileCard = true
                    }
                }
            }
        } label: {
            HStack(alignment: .center, spacing: 10) {
                WebImage(url: toUser.image1?.imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipped()
                    .cornerRadius(40)
                    .shadow(radius: 1)
                Text(toUser.firstName ?? "User")
                    .foregroundColor(colorScheme == .dark ? Color.white: Color.black)
                    .font(.headline)
            }
        }
    }
}

struct customNavBar_Previews: PreviewProvider {
    static var previews: some View {
        customNavBar(toUser: Binding.constant(ChatUser(id: "QvV4OoZmZ3QWHhMNaZrr7lkqmLF3", firstName: "Jason", lastName: "Kalkanus", image1: ProfileImage(imageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/amore-f8cd6.appspot.com/o/images%2FQvV4OoZmZ3QWHhMNaZrr7lkqmLF3%2Fimage1640439314.5542731.heic?alt=media&token=cb324857-1cf9-4ee1-b208-ddba11751275") , firebaseImagePath: "images/QvV4OoZmZ3QWHhMNaZrr7lkqmLF3/image1640439314.5542731.heic"))), presentProfileCard: Binding.constant(false))
            .environmentObject(MainMessagesViewModel())
    }
}
