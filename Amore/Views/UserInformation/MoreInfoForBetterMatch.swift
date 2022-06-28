//
//  MoreInfoForBetterMatch.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/15/21.
//

import SwiftUI
import Firebase

struct MoreInfoForBetterMatch: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @State var moreInfoView: MoreInformation = .introInfoHomeView
    @State private var progressStatus = 0.0
    @Binding var showSheetView: Bool
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]),
                       startPoint: .top,
                       endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                
                VStack {
                    
                    ProgressView(value: progressStatus, total: 100)
                        .progressViewStyle(WithBackgroundProgressViewStyle())
                        .padding(.horizontal,20)
                        .padding(.top,4)
                    
                    Spacer()
                        
                    Group {
                        switch moreInfoView {
                            
                            case .introInfoHomeView:
                                IntroductionOption(moreInfoView:$moreInfoView,
                                                   progressStatus:$progressStatus,
                                                   showSheetView:$showSheetView)
                            
                            case .userHeightView:
                                UserHeight(userHeight:$profileModel.editUserProfile.height.boundDouble,
                                           moreInfoView:$moreInfoView,
                                           progressStatus:$progressStatus)
                            
                            case .doYouWorkOutView:
                                QuestionaireTemplate(question: "Do you workout?",
                                                     listOfOptions: ["Everyday", "Sometimes", "Never"],
                                                     userChoice: $profileModel.editUserProfile.doYouWorkOut,
                                                     moreInfoView:$moreInfoView,
                                                     moreInfoViewStatus:.highestEducationView,
                                                     progressStatus:$progressStatus)
                                
                            case .highestEducationView:
                                QuestionaireTemplate(question: "What's your highest education?",
                                                 listOfOptions: ["Doctor PhD", "Masters", "Professional Degree","Bachelors","High School"],
                                                 userChoice: $profileModel.editUserProfile.education,
                                                 moreInfoView:$moreInfoView,
                                                 moreInfoViewStatus:.doYourDrinkView,
                                                 progressStatus:$progressStatus)
                            
                            case .doYourDrinkView:
                                QuestionaireTemplate(question: "Do you drink?",
                                             listOfOptions: ["Sometimes", "Occasionally", "Never"],
                                             userChoice: $profileModel.editUserProfile.doYouDrink,
                                             moreInfoView:$moreInfoView,
                                             moreInfoViewStatus:.doYouSmokeView,
                                             progressStatus:$progressStatus)
                        
                            case .doYouSmokeView:
                                QuestionaireTemplate(question: "Do you smoke?",
                                         listOfOptions: ["Sometimes", "Never"],
                                         userChoice: $profileModel.editUserProfile.doYouSmoke,
                                         moreInfoView:$moreInfoView,
                                         moreInfoViewStatus:.doYouWantBabies,
                                         progressStatus:$progressStatus)
                            
                            case .doYouWantBabies:
                                QuestionaireTemplate(question: "Do you ever want babies?",
                                     listOfOptions: ["Yes", "Maybe Someday","Never"],
                                     userChoice: $profileModel.editUserProfile.doYouWantBabies,
                                     moreInfoView:$moreInfoView,
                                     moreInfoViewStatus:.completed,
                                     progressStatus:$progressStatus)
                            
                            case .completed:
                                Completed(showSheetView:$showSheetView)
                                    .onAppear {
                                        // Only update the user profile once user has complete the entire Questionnaire
                                        profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid)
                                    }
                            }
                        }
                    
                    Spacer()
                    
                }
                .onAppear{
                    
                    if profileModel.editUserProfile.height == nil {
                        profileModel.editUserProfile.height = 167.64
                    }
                }
                .onDisappear {
                    // Before disappear check if user Completed the entire questionnaire?
                    /// If user completed the entire questionaire template this will not be called
                    /// Only called if user closes the questionnaire before completing it, we need to revert back to userProfile
                    if profileModel.editUserProfile != profileModel.userProfile {
                        profileModel.editUserProfile = profileModel.userProfile
                    }
                }
                
            )
        
    }
}

struct WithBackgroundProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .padding(8)
            .background(Color.gray.opacity(0.25))
            .accentColor(.white)
            .cornerRadius(8)
    }
}


struct MoreInfoForBetterMatch_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfoForBetterMatch(showSheetView: Binding.constant(false))
    }
}
