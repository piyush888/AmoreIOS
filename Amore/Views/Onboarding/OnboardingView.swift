//
//  OnboardingView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/20/21.
//

import SwiftUI
import FirebaseAuth


struct OnboardingView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var profileModel = ProfileViewModel()
    @EnvironmentObject var model: OnboardingModel
    @State var tabSelectionIndex = 0
    @State var loggedIn: Bool = false
    @State var loginFormVisible = false
    @State var oldUser: Bool = false
    @State var profileCores = [ProfileCore]()
    
    func fetchProfileCoreData () {
        profileModel.getUserProfile(context: viewContext)
        let request = ProfileCore.profileFetchRequest()
        request.sortDescriptors = []
        if let currentUserId = Auth.auth().currentUser?.uid{
            print("Looking for: \(currentUserId)")
            request.predicate = NSPredicate(format: "id contains[c] %@", currentUserId)
        }
        do {
            let results = try viewContext.fetch(request)
            self.profileCores = results
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func checkLogin() {
        loggedIn = Auth.auth().currentUser == nil ? false : true
        print("Logged In: "+String(loggedIn))
    }
    
    func checkOldUser() {
        var profileCore: ProfileCore?
        if (profileCores.count>0){
            profileCore = profileCores[0]
        }
        print("Info from Core Data Store : Profile Email=\(profileCore?.email ?? "default value")")
        if profileCore?.email != nil {
            oldUser = true
        }
        else {
            oldUser = false
        }
    }
    
    var body: some View {
        
        if !loggedIn {
            // Onboarding View - Logged Out
            VStack {
                
                Spacer()
                
                TabView(selection: $tabSelectionIndex){
                        ForEach(0..<model.onboardingsData.count) { index in
                            // Pictures, Onboarding Heading & Onboarding SubText
                            OnboardingCards(
                                boardingtitle: model.onboardingsData[index].onboardingtitle,
                                boardingtext: model.onboardingsData[index].onboardingtext,
                                image: model.onboardingsData[index].image
                            )
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
                
                
                // Sign In/Sign Up Button
                VStack{
                    Button{
                        loginFormVisible = true
                    } label : {
                        ZStack{
                            Rectangle()
                                .frame(height:45)
                                .cornerRadius(5.0)
                                .foregroundColor(.pink)
                                .padding(.horizontal,44)
                            
                            Text("Sign In/Sign Up")
                                .foregroundColor(.white)
                                .bold()
                                .font(.BoardingButton)
                        }
                    }
                    .sheet(isPresented: $loginFormVisible, onDismiss: {
                        checkLogin()
                    }) {
                        Number(loginFormVisible: $loginFormVisible)
                            .environmentObject(profileModel)
                    }
                }
                .padding(.horizontal,44)
                .padding(.bottom,44)
                
                Spacer()
                
            }
            .onAppear{
                checkLogin()
            }
        }
        else {
            // Home View/Profile View -- Logged In
            //            HomeView(loggedIn: $loggedIn)
            if (profileModel.profileRefreshDone) {
                ZStack {
                    if oldUser {
                        HomeView(loggedIn: $loggedIn)
                    }
                    else {
                        BasicUserInfo(oldUser: $oldUser)
                            .environmentObject(profileModel)
                    }
                }
                .onAppear{
                    print("Primary profile refresh: \(profileModel.profileRefreshDone)")
                    self.fetchProfileCoreData()
                    checkOldUser()
                }
            }
            else {
                Text("Please Wait...")
                    .onAppear{
                        print("Secondary profile refresh: \(profileModel.profileRefreshDone)")
                        self.fetchProfileCoreData()
                        checkOldUser()
                    }
            }
            
        }
        
    }
}

struct OnboardingOneView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(OnboardingModel())
    }
}
