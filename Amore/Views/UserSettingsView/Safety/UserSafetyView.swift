//
//  UserSafetyView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/22/21.
//

import SwiftUI


struct SafetyViewModel:Identifiable {
    var id: String
    var image: String?
    var illustration: String?
    var title: String
    var body: String?
    var frameHeight: Double
    var colorScheme: Color?
    var contentUrl: String?
}

var safety = SafetyViewModel(id:"1",
                             image:"shield.fill",
                             title:"Safety",
                             body:"Keep your community safe & be supportive of other people choices",
                             frameHeight:90,
                             colorScheme: Color.green,
                             contentUrl: "https://www.luvamore.com/safetytips")
                     
var protection = SafetyViewModel(id:"2",
                             image:"eye.circle.fill",
                             title:"Protection",
                             body:"See something, Say something, Be our eyes and ears",
                             frameHeight:90,
                             colorScheme: Color.yellow,
                             contentUrl: "https://www.luvamore.com/about")

var report = SafetyViewModel(id:"3",image:"exclamationmark.octagon.fill",
                            title:"Report",
                            body:"Report fake accounts, activities & child abuse",
                            frameHeight:90,
                            colorScheme: Color.red,
                            contentUrl: "https://www.luvamore.com/communityguidelines")

var safetyArticlesList:[SafetyViewModel] = [
        SafetyViewModel(id:"4",
            illustration: "BlogArticle1",
            title:"Love at First Sight",
            body:"Is it still valid in 2023?",
            frameHeight:120,
            contentUrl:"https://www.luvamore.com/post/love-at-first-sight"),
        SafetyViewModel(id:"5",
            illustration: "BlogArticle2",
            title:"The Future of Dating",
            body:"Harnessing the Power of Transformers to Revolutionize Matchmaking",
            frameHeight:120,
            contentUrl:"https://www.luvamore.com/post/10-ads-you-should-learn-from"),
        SafetyViewModel(id:"6",
            illustration: "BlogArticle3",
            title:"Things to do on your first date",
            body:"First dates can be exciting, but they can also be nerve-wracking.",
            frameHeight:120,
            contentUrl:"https://www.luvamore.com/post/thing-to-do-on-first-date")]

var quiz = SafetyViewModel(id:"7",
                image:"q.circle",
                title:"Safety Quiz",
                body:"Take safety quiz and make the most out of your dating experience.",
                frameHeight:90,
                colorScheme: Color(hex:0xDA46EB))

struct UserSafetyView: View {
    
    @Environment(\.colorScheme) var phoneColorScheme
    
    @State private var showSafetyTips = false
    @State private var userInput = ""
    @State private var showSafari: Bool = false
    @State private var showQuiz: Bool = false
    // Should be "" here, fix for a bug - KTZ
    @State var urlToOpen: String = "https://www.luvamore.com/safetytips"
    
    
    // Card color of the quiz
    var sheetColor: Gradient {
        phoneColorScheme == .dark ? Gradient(colors: [Color(.systemGray6)]) : Gradient(colors: [Color(hex:0xF2E9FE)])
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    TextSlider()
                        .frame(height: geometry.size.height * 0.30)
                        .padding(.horizontal,15)
                    
                    SafetyCardWrapperView(cardSafety: safety,
                                   maxWidth:.infinity,
                                   showSafari:$showSafari,
                                   urlToOpen:$urlToOpen)
                    
                    SafetyCardWrapperView(cardSafety: protection,
                                   maxWidth:.infinity,
                                   showSafari:$showSafari,
                                   urlToOpen:$urlToOpen)
                    
                    SafetyCardWrapperView(cardSafety: report,
                                   maxWidth:.infinity,
                                   showSafari:$showSafari,
                                   urlToOpen:$urlToOpen)
                        
                    
                    // Safety Articles
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 10) {
                            ForEach(safetyArticlesList) { article in
                                
                                SafetyCardWrapperView(cardSafety: article,
                                               maxWidth:geometry.size.width*0.75,
                                               showSafari:$showSafari,
                                               urlToOpen:$urlToOpen)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Quiz
                    SafetyCardView(cardSafety: quiz,
                                   maxWidth:.infinity)
                    .onTapGesture {
                        self.showQuiz=true
                    }
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Safety")
                .sheet(isPresented: $showSafari, content: {
                    // KTZ TODO not sure why this breaks if urlToOpen is intialized with ""
                    // Fix the loading of SFSafariViewWrapper first time in this view
                    // urlToOpen binding doesn't get updated in first time
                    SFSafariViewWrapper(url: URL(string: urlToOpen)!)
                })
                .sheet(isPresented: $showQuiz, content: {
                    SafetyQuizView(showQuiz:$showQuiz)
                })
            }
            .padding(10)
        }
    }
}

struct UserSafetyView_Previews: PreviewProvider {
    static var previews: some View {
        UserSafetyView()
    }
}
