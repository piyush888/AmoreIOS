//
//  StreamViewModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/17/21.
//

import SwiftUI
import StreamChat
import JWTKit
import Firebase


class StreamViewModel: ObservableObject {
    
    // Alert....
    @Published var showAlert = false
    @Published var errorMsg = ""
    
    // Loading Screen...
    @Published var isLoading = false
    
    // Channel Data...
    @Published var channels : [ChatChannelController.ObservableObject]!
    
    // Create New Channel...
    @Published var createNewChannel = false
    @Published var channelName = ""
    
    // Gets called after the onboarding forms are completed
    // Use this to update the UserName and Image in Stream Chat
    func createUserProfileInStream(userName: String){
        
        // Logging In User....
        withAnimation{isLoading = true}
        
        // Upadting User Profile...
        // you can give user image url if want....
        ChatClient.shared.currentUserController().updateUserData(name: userName, imageURL: nil, userExtraData: .defaultValue) { err in
            
            withAnimation{self.isLoading = false}
            if let error = err{
                self.errorMsg = error.localizedDescription
                self.showAlert.toggle()
                return
            }
            ChatClient.shared.currentUserController().reloadUserIfNeeded()
        }
    }
    
    // Get called from 2 places :
    ///  From SignIn() when user logs in
    ///  From AppDelegate incase user is alredy logged in to reload ChatClient
    func streamLogin(uid: String) {
        // Verifying if user is already in stream SDk or Not...
        // for that we need to intialize the stream sdk with JWT Tokens...
        // AKA known as Authenticatiog with stream SDK....
        // generating JWT Token...
        let signers = JWTSigners()
        signers.use(.hs256(key: streamSecretKey.data(using: .utf8)!))
        
        // Creating Payload and inserting Userd ID to generate Token..
        // Here User ID will be Firebase UID....
        // Since its Unique...
        let payload = PayLoad(user_id: uid)
        // generating Token...
        do{
            let jwt = try signers.sign(payload)
            print(jwt)
            let config = ChatClientConfig(apiKeyString: streamAPIKey)
            let tokenProvider = TokenProvider.closure { client, completion in
                guard let token = try? Token(rawValue: jwt) else{
                    self.reportError()
                    return
                }
                completion(.success(token))
            }
            ChatClient.shared = ChatClient(config: config, tokenProvider: tokenProvider)
            // Reloading ChatClient...
            ChatClient.shared.currentUserController().reloadUserIfNeeded()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    
    // Fetching All Channels...
    func fetchAllChannels(){
        
        if channels == nil{
            // filter...
            
            ChatClient.shared.currentUserController().reloadUserIfNeeded()
            
            let filter = Filter<ChannelListFilterScope>.equal("type", to: "messaging")
            
            let request =  ChatClient.shared.channelListController(query: .init(filter: filter))
            
            request.synchronize { (err) in
                if let error = err{
                    self.errorMsg = error.localizedDescription
                    self.showAlert.toggle()
                    return
                }

                DispatchQueue.main.async {
                    
                    // else Successful...
                    self.channels = request.channels.compactMap({ (channel) -> ChatChannelController.ObservableObject? in
                        
                        return ChatClient.shared.channelController(for: channel.cid).observableObject
                    })
                }
            }
        }
    }
    
    // Creating New CHannel...
    func createChannel(){
        
        withAnimation{self.isLoading = true}
        
        let normalizedChannelName = channelName.replacingOccurrences(of: " ", with: "-")
        
        let newChannel = ChannelId(type: .messaging, id: normalizedChannelName)
        
        // you can givve image url to channel...
        // same you can also give image url to user....
        let request = try! ChatClient.shared.channelController(createChannelWithId: newChannel, name: normalizedChannelName, imageURL: nil, extraData: .defaultValue)
        
        request.synchronize { (err) in
            
            withAnimation{self.isLoading = false}
            
            if let error = err{
                self.errorMsg = "Try Again Later !!!\n\nAvoid Using Special Character like $,'%..etc\n\n\(error.localizedDescription)"
                self.showAlert.toggle()
                return
            }
            
            // Succes....
            // closing Loading And New Channle View....
            self.channelName = ""
            withAnimation{self.createNewChannel = false}
            self.channels = nil
            self.fetchAllChannels()
        }
    }

    // Reporting Error...
    func reportError(){
        self.errorMsg = "Please try again later !!!"
        self.showAlert.toggle()
    }
    
}

struct PayLoad: JWTPayload,Equatable {
    
    enum CodingKeys: String,CodingKey {
        case user_id
    }
    
    var user_id: String
    
    func verify(using signer: JWTSigner) throws {
        
    }
}

