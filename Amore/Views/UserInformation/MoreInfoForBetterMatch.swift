//
//  MoreInfoForBetterMatch.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/15/21.
//

import SwiftUI

struct MoreInfoForBetterMatch: View {
    
    @State var moreInfoView: MoreInformation = .introInfoHomeView
    @State private var progressStatus = 0.0
    @State var userHeight = 5.3
    @State var workoutSelection: String? = nil
    @State var educationSelection: String? = nil
    @State var drinkingSelection: String? = nil
    @State var smokingSelection: String? = nil
    @State var babiesSelection: String? = nil
    
    
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
                    
                    Spacer()
                        
                    Group {
                        switch moreInfoView {
                            
                            case .introInfoHomeView:
                                IntroductionOption(moreInfoView:$moreInfoView,
                                                   progressStatus:$progressStatus)
                            
                            case .userHeightView:
                                UserHeight(userHeight:$userHeight,
                                           moreInfoView:$moreInfoView,
                                           progressStatus:$progressStatus)
                            
                            case .doYouWorkOutView:
                                QuestionaireTemplate(question: "Do you workout?",
                                                     listOfOptions: ["Everyday", "Sometimes", "Never"],
                                                     userChoice: $workoutSelection,
                                                     moreInfoView:$moreInfoView,
                                                     moreInfoViewStatus:.doYourDrinkView,
                                                     progressStatus:$progressStatus)
                                
                            case .highestEducationView:
                                QuestionaireTemplate(question: "What's your highest education?",
                                                 listOfOptions: ["Doctor PhD", "Masters", "Professional Degree","Bachelors","High School"],
                                                 userChoice: $educationSelection,
                                                 moreInfoView:$moreInfoView,
                                                 moreInfoViewStatus:.doYourDrinkView,
                                                 progressStatus:$progressStatus)
                            
                            case .doYourDrinkView:
                                QuestionaireTemplate(question: "Do you drink?",
                                             listOfOptions: ["Sometimes", "Occasionally", "Never"],
                                             userChoice: $drinkingSelection,
                                             moreInfoView:$moreInfoView,
                                             moreInfoViewStatus:.doYouSmokeView,
                                             progressStatus:$progressStatus)
                        
                            case .doYouSmokeView:
                                QuestionaireTemplate(question: "Do you smoke?",
                                         listOfOptions: ["Sometimes", "Never"],
                                         userChoice: $smokingSelection,
                                         moreInfoView:$moreInfoView,
                                         moreInfoViewStatus:.doYouWantBabies,
                                         progressStatus:$progressStatus)
                            
                            case .doYouWantBabies:
                                QuestionaireTemplate(question: "Do you ever want babies?",
                                     listOfOptions: ["Yes", "Maybe Someday","Never"],
                                     userChoice: $babiesSelection,
                                     moreInfoView:$moreInfoView,
                                     moreInfoViewStatus:.completed,
                                     progressStatus:$progressStatus)
                            
                            case .completed:
                                Completed()
                            }
                        }
                    
                    Spacer()
                    
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
        MoreInfoForBetterMatch()
    }
}
