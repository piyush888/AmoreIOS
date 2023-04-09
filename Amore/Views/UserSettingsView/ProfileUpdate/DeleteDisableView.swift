//
//  DeleteDisableView.swift
//  Amore
//
//  Created by Piyush Garg on 24/08/22.
//

import SwiftUI
import Firebase

struct DeleteDisableView: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    
    @State var showDeleteAlert: Bool = false
    @State var showDeactivateAlert: Bool = false
    
    func logOutAction() { // remove FCM token TODO
        adminAuthenticationModel.removeCookies()
        // Firestore logout
        try! Auth.auth().signOut()
        UserDefaults.standard.set(false, forKey: "log_Status")
    }
    
    func deactivateAction() {
        DispatchQueue.main.async {
            print("Resetting Photos...")
            photoModel.resetPhotosOnLogout()
            profileModel.editUserProfile.isProfileActive = false
            profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid, completion: logOutAction)
        }
    }
    
    func deleteAction() {
        print("Deleting account...")
        DispatchQueue.main.async {
            profileModel.editUserProfile.deleteInitiatedDate = Date()
            deactivateAction()
        }
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Image(systemName: "person.crop.circle.fill.badge.xmark")
                .renderingMode(.original)
                .resizable()
                .frame(width:100, height:85)
                .padding(.vertical, 20)
            
            Text("We're sad to see you go!")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            Text("You can also deactivate your account if you want to take a break and not lose all your profile data. If you choose to deactivate, your profile shall be hidden from other users.")
                .font(.body)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            VStack {
                // Deactivate Account Button
                Button{
                    showDeactivateAlert = true
                } label : {
                    ContinueButtonDesign(buttonText:"Deactivate my account")
                }
                .alert(isPresented: $showDeactivateAlert) {
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text("Your account will be deactivated and you'll be logged out of your account. You can log in again anytime to reactivate your account."),
                        primaryButton: .destructive(
                            Text("Deactivate"),
                            action: deactivateAction
                        ),
                        secondaryButton: .cancel()
                    )
                }
                .padding()
                
                // Delete Account Button
                Button{
                    showDeleteAlert = true
                } label : {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Delete my account")
                    }
                    .foregroundColor(.pink)
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Are you sure you want to delete the account?"),
                        message: Text("Deletion of User Account will result in loss of all data including messages, matches and likes received. We will retain a copy of your data for 30 days. Should you happen to login during that time, you'll be able to resume your account."),
                        primaryButton: .destructive(
                            Text("Delete Account"),
                            action: deleteAction
                        ),
                        secondaryButton: .cancel()
                    )
                }
                .padding()
            }
            
            Spacer()
            
        }
        .padding()
        .navigationBarTitle("Delete Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DeleteDisableView_Previews: PreviewProvider {
    static var previews: some View {
        
        sampleCard
            .previewDisplayName("iPhone 13 Pro Max")
            .previewDevice("iPhone 13 Pro Max")
        
        
        sampleCard
            .previewDisplayName("iPhone 13 Mini")
            .previewDevice("iPhone 13 Mini")
        
        
        sampleCard
            .previewDisplayName("iPhone 12 Pro")
            .previewDevice("iPhone 12 Pro")
        
        sampleCard
            .previewDisplayName("iPhone 11")
            .previewDevice("iPhone 11")
    }
    
    static var sampleCard: some View {
        DeleteDisableView()
            .environmentObject(ProfileViewModel())
            .environmentObject(PhotoModel())
            .environmentObject(AdminAuthenticationViewModel())
    }
}
