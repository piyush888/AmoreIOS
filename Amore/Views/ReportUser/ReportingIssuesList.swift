//
//  ReportingIssuesCard.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/16/21.
//

import SwiftUI

struct ReportingIssuesCard: View {
    
    @EnvironmentObject var reportActivityModel: ReportActivityModel
    
    @Binding var safetyButton: Bool
    @State var profileId: String
    @Binding var showingAlert: Bool
    private var onRemove: (_ user: String) -> Void
    
    init(safetyButton: Binding<Bool>, profileId: String, showingAlert:Binding<Bool>, onRemove: @escaping (_ user: String) -> Void) {
        _safetyButton = safetyButton
        self.profileId = profileId
        _showingAlert = showingAlert
        self.onRemove = onRemove
    }
    
    @State private var reportUserDescription:String?
    @State private var selectedReasoning = "Other Reason"
    let reportUserReasoning = ["Inappropriate photos",
                               "Under age user and below 18",
                               "User is soliciting sex",
                               "Sexual profile",
                               "Violet/Hate speech bio",
                               "Spam/Fake profile",
                               "User is advertising",
                               "I know user, user did something wrong",
                               "Report User for other actions",
                               "User asked for money",
                               "Other Reason"]

    
    var body: some View {
        
            GeometryReader { geometry in
                
                VStack {
                    
                    HStack {
                        Spacer()
                        Button {
                            self.safetyButton.toggle()
                        } label: {
                            Text("Cancel")
                        }
                    }.padding(.top)
                    
                    TextSlider()
                        
                    RadioButtonGroup(items: reportUserReasoning, selectedId: selectedReasoning) { selected in
                            print("Selected is: \(selected)")
                    }
                    
                    // Please provide information why you want to report user
                    EditCardForm(formHeight: 100.0,
                                 formHeadLine: "Tell us more",
                                 formInput: $reportUserDescription)
                        .foregroundColor(Color.black)
                    
                    Button {
                        
                        reportActivityModel.reportUserWithReason(profileBeingReportedId:profileId,
                                                                 reason:selectedReasoning,
                                                                 description:reportUserDescription.bound,
                                                                 onFailure:{
                                                                    self.showingAlert = true
                                                                    print("Failed to report user, please try again")
                                                                },
                                                                 onSuccess: {
                                                                    print("Failed to report user, please try again")
                                                                    // If Success also remove the card from deck
                                                                    FirestoreServices.storeLikesDislikes(apiToBeUsed: "/storelikesdislikes", onFailure: {
                                                                        print("Failed to remove card from deck")
                                                                        self.showingAlert = true
                                                                        return
                                                                    }, onSuccess: {
                                                                        print("Successfully removed card from deck")
                                                                    }, swipedUserId: self.profileId, swipeInfo: .dislike)
                                                                        self.onRemove(self.profileId)
                                                                }
                        )
                        self.safetyButton.toggle()
                        
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.yellow]),
                                    startPoint: .leading,
                                    endPoint: .trailing)
                                )
                                .frame(width:geometry.size.width*0.50, height:geometry.size.height/18)
                            
                            VStack {
                                Text("Submit")
                                    .font(.headline)
                            }
                        }
                        .foregroundColor(.white)
                        
                    }
                    
                }
                .navigationBarItems(trailing: Button(action: {
                    self.safetyButton.toggle()
                }) {
                    Text("Done").bold()
                })
                
            }
            .padding(.horizontal)
            .padding(.bottom,20)
    }
}



