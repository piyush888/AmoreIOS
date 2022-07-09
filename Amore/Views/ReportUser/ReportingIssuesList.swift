//
//  ReportingIssuesCard.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/16/21.
//

import SwiftUI
import RiveRuntime

struct ReportingIssuesCard: View {
    
    @EnvironmentObject var reportActivityModel: ReportActivityModel
    
    @Binding var allcardsActiveSheet: AllCardsActiveSheet?
    @State var profileId: String
    @Binding var showingAlert: Bool
    private var onRemove: (_ user: String) -> Void
    
    init(allcardsActiveSheet: Binding<AllCardsActiveSheet?>, profileId: String, showingAlert:Binding<Bool>, onRemove: @escaping (_ user: String) -> Void) {
        _allcardsActiveSheet = allcardsActiveSheet
        self.profileId = profileId
        _showingAlert = showingAlert
        self.onRemove = onRemove
    }
    
    @State private var reportUserDescription:String?
    @State private var selectedReasoning = "Other Reason"
    var reportUserReasoning = ["Inappropriate photos",
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
        
        ZStack {
            Color("Background").ignoresSafeArea()
            
            GeometryReader { geometry in
                
                VStack {
                    
                    // Done Button to close the sheet
                    HStack {
                        Spacer()
                        Button {
                            self.allcardsActiveSheet = nil
                        } label: {
                            DoneButton()
                        }
                    }
                    .padding(.top,10)
                    .padding(.horizontal,10)
                    
                    // Carousel of images and information
                    TextSlider()
                        .frame(height: geometry.size.height * 0.30)
                        .padding(.horizontal,15)
                    
                    overlayContent
                    
                    Spacer()
                    
//                    // Please provide information why you want to report user
//                    EditCardForm(formHeight: 100.0,
//                                 formHeadLine: "Tell us more",
//                                 formInput: $reportUserDescription)
//                        .foregroundColor(Color.black)
//
                    // Report the activity
                    Button {
                        // call this function to report user, if successfully remove the card from deck
                        ReportActivityModel.reportUserWithReason(otherUserId:self.profileId,
                                                                 reason:selectedReasoning,
                                                                 description:reportUserDescription.bound,
                                                                 onFailure:{
                                                                    self.showingAlert = true
                                                                    print("Failed to report user, please try again")
                                                                },
                                                                 onSuccess: {
                                                                    print("Successfully reported user")
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
                        self.allcardsActiveSheet = nil

                    } label: {
                        VStack {
                            Text("Report Profile")
                                .bold()
                            Text("User profile will be locked until our review")
                                .font(.caption)
                        }
                        .reportProfileButton()
                        .padding()
                    }
                    
                    
                }
                
                
            }
            .background(
                Image("Blob 1")
                    .offset(x: 250, y: -100)
            )
        }
    }
    
    var overlayContent: some View {
        
            // Give users an option to select the reasons why they are reporting user
            RadioButtonGroup(items: reportUserReasoning,
                             selectedId: selectedReasoning) { selected in
                selectedReasoning = selected
                print("Radio Button Selected: \(selectedReasoning)")
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(LinearGradient(
                                gradient: Gradient(colors: [Color(hex:0x61F4DE),Color(hex:0xFF6EE0)]),
                                startPoint: .bottomLeading,
                                endPoint: .top))
                        .blur(radius: 50)
                        .opacity(0.5)
            )
            .padding(.horizontal,20)
    }
}

struct ReportingIssuesCard_Previews: PreviewProvider {
    
    @State var allcardsActiveSheet: AllCardsActiveSheet?
    
    static var previews: some View {
        ReportingIssuesCard(allcardsActiveSheet: Binding.constant(AllCardsActiveSheet.reportProfileSheet),
                            profileId: "TestId",
                            showingAlert:Binding.constant(false),
                            onRemove: { user in
                                print("Testing reporting issue")
                            }
                        )
    }
}

