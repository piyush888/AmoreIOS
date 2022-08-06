//
//  OnboardingView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 8/1/22.
//

import SwiftUI
import UIKit

struct OnboardingView: View {
    
    @State private var showSafari: Bool = false
    @State var urlOpenWebPage: String = "https://aidronesoftware.com/education"
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    @StateObject var firebaseSvcObj = FirebaseServices()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationView {
            // Onboarding View - Logged Out
                VStack {
                    Spacer()
                    
                    // Amore headline and sub text
                    VStack {
                        Text("Amore")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(Color.pink)
                        
                        HStack {
                            Text("Designed by it's users ")
                                .font(.caption)
                            Image(systemName: "questionmark.circle")
                                .frame(width: 5)
                        }
                        .foregroundColor(Color.gray)
                        .onTapGesture {
                            self.showSafari.toggle()
                        }.fullScreenCover(isPresented: $showSafari, content: {
                            SFSafariViewWrapper(url: URL(string: self.urlOpenWebPage)!)
                        })
                        
                    }
                    
                    // Onboarding Swipeable Illustrations
                    OnboardingAllCards()
                    
                    // Navigate to the Login Phone Number
                    NavigationLink {
                        LoginPhoneNumber()
                            .environmentObject(profileModel)
                            .environmentObject(adminAuthenticationModel)
                            .environmentObject(firebaseSvcObj)
                        
                    } label: {
                        buttonSignInSignUp
                    }
                    
                    Spacer()
                    
                    // Signin/Sign Up Button - Mobile Number - OTP Login
                    TextLabelWithHyperlink()
                        .padding(.horizontal, 20)
                        .frame(height: 50)
                    
                }
                .padding(.vertical, 60)
                .navigationBarHidden(true)
        }
    }
    
    var buttonSignInSignUp: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.pink)
                .frame(height:60)
                
            Text("Sign In/Sign Up")
                .bold()
                .padding(.horizontal,20)
                .foregroundColor(Color.white)
        }
        .padding(.horizontal, 40)
    }
    
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            OnboardingView().preferredColorScheme($0)
                .environmentObject(ProfileViewModel())
                .environmentObject(AdminAuthenticationViewModel())
        }
    }
}


struct TextLabelWithHyperlink: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UITextView {
        
        let standartTextAttributes: [NSAttributedString.Key : Any] = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        
        let attributedText = NSMutableAttributedString(string: "By tapping Sign In/Sign Up, you agree to our ")
        attributedText.addAttributes(standartTextAttributes, range: attributedText.range) // check extention
        
        let hyperlinkTextAttributes1: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.link: "https://aidronesoftware.com"
        ]
        let textWithHyperlink1 = NSMutableAttributedString(string: "Terms")
        textWithHyperlink1.addAttributes(hyperlinkTextAttributes1, range: textWithHyperlink1.range)
        attributedText.append(textWithHyperlink1)
        
        let endOfAttrString = NSMutableAttributedString(string: ". You can learn how we process your data in our ")
        endOfAttrString.addAttributes(standartTextAttributes, range: endOfAttrString.range)
        attributedText.append(endOfAttrString)
        
        
        let hyperlinkTextAttributes2: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.link: "https://aidronesoftware.com/education"
        ]
        let textWithHyperlink2 = NSMutableAttributedString(string: "Privacy Polocy")
        textWithHyperlink2.addAttributes(hyperlinkTextAttributes2, range: textWithHyperlink2.range)
        attributedText.append(textWithHyperlink2)
        
        
        let endOfAttrString2 = NSMutableAttributedString(string: " and ")
        endOfAttrString2.addAttributes(standartTextAttributes, range: endOfAttrString2.range)
        attributedText.append(endOfAttrString2)
        
        
        let hyperlinkTextAttributes3: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.link: "https://aidronesoftware.com/contactus"
        ]
        let textWithHyperlink3 = NSMutableAttributedString(string: "Cookies Policy")
        textWithHyperlink3.addAttributes(hyperlinkTextAttributes3, range: textWithHyperlink3.range)
        attributedText.append(textWithHyperlink3)
        
        
        let textView = UITextView()
        textView.attributedText = attributedText
        
        textView.isEditable = false
        textView.textAlignment = .center
        textView.isSelectable = true
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {}
    
}

extension NSMutableAttributedString {
    
    var range: NSRange {
        NSRange(location: 0, length: self.length)
    }
    
}
