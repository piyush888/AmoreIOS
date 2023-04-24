//
//  BasicUserInfoForm.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/25/21.
//

import SwiftUI
import FirebaseAuth

struct BasicUserInfoForm: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    
    @State var lastName: String? = ""
    @State var firstName: String? = ""
    @State var email: String? = ""
    @State var dateOfBirth: Date = Date()
    
    @State var allFieldsFilled: Bool = false
    @State var errorDesc: String = ""
    @State var showAlert: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        let isEmailValid = emailPredicate.evaluate(with: email)
        if !isEmailValid {
            self.errorDesc = "Invalid Email"
        }
        return isEmailValid
    }
    
    var age: Int {
        let now = Date()
        let birthday: Date = profileModel.userProfile.dateOfBirth ?? Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        return ageComponents.year!
    }
    
    var isDOBValid: Bool {
        // Age can't be more than 110 years and less than 18 year
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        let age = ageComponents.year!
        
        // Age can't be more than 70 years
        if((age > 70) || (age<18)) {
            if(age>70) {
                self.errorDesc = "Your age can't be more than 80 years"
            } else {
                self.errorDesc = "Minimum age of 18 years is required to signup."
            }
            return false
        } else {
            return true
        }
    }
    
    func addInputToProfile() {
        profileModel.userProfile.lastName = lastName
        profileModel.userProfile.firstName = firstName
        profileModel.userProfile.email = email
        profileModel.userProfile.dateOfBirth = dateOfBirth
        profileModel.userProfile.age = age
        profileModel.userProfile.id = Auth.auth().currentUser?.uid
    }
    
    func whitespaceTrimmer (str: String) -> String {
        return str.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func checkallFieldsFilled () {
        self.errorDesc = ""
        self.showAlert = false
        firstName = whitespaceTrimmer(str: firstName ?? "")
        lastName = whitespaceTrimmer(str: lastName ?? "")
        email = whitespaceTrimmer(str: email ?? "")
        
        
        if firstName != "" && lastName != "" && email != "" && isEmailValid && isDOBValid {
            addInputToProfile()
            self.allFieldsFilled = true
        } else {
            self.showAlert = true
            if isEmailValid && isDOBValid {
                self.errorDesc = "Please fill all the above details"
            }
        }
    }
    
    var body: some View {
        
        
            NavigationView {
                VStack {
                
                    Form {
                        Group {
                            Section(header: Text("Name")) {
                                EditCardForm(formHeight: 40.0,
                                                formHeadLine: "First Name",
                                                formInput: $firstName,
                                                maxChars:30)
                                
                                EditCardForm(formHeight: 40.0,
                                                formHeadLine: "Last Name",
                                                formInput: $lastName,
                                                maxChars:30)
                            }
                            
                            Section(header:Text("Date of Birth")) {
                                DatePicker(selection: $dateOfBirth, in: ...Date(), displayedComponents: .date) {
                                        HStack {
                                            Image(systemName:"calendar")
                                                .foregroundColor(.accentColor)
                                        }
                                    }
                            }
                            
                            Section(header: Text("Email")) {
                                EditCardForm(formHeight: 40.0,
                                                formHeadLine: "Email address",
                                                formInput: $email,
                                                maxChars:30)
                            }
                            

                            
                        }
                    }
                 
                    if errorDesc != "" {
                        Text("\(errorDesc)")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.pink)
                            .padding(.horizontal,40)
                    }
                    
                    // Navigate or continue to next view
                    navigationButton
                        .padding(.horizontal,20)
                }
                .onTapGesture {
                    self.hideKeyboard()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Alert"),
                          message: Text("\(self.errorDesc)"),
                          dismissButton: Alert.Button.default(
                              Text("OK"), action: {
                                  self.errorDesc = ""
                              })
                    )
                }
                .navigationTitle("Create profile")
                .navigationBarTitleDisplayMode(.inline)
                .padding(.bottom,20)

                
        }
    }
    
    var navigationButton: some View {
        NavigationLink(
            destination: Passions()
                .environmentObject(profileModel),
            isActive: $allFieldsFilled,
            label: {
                Button{
                    DispatchQueue.main.async {
                        checkallFieldsFilled()
                    }
                } label : {
                    ContinueButtonDesign(buttonText:"Continue")
                }
                .padding(.horizontal,30)
                .padding(.top,10)
            })
    }
}

struct BasicUserInfoForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BasicUserInfoForm()
                .environmentObject(ProfileViewModel())
                .previewDisplayName("iPhone 13 Pro Max")
                .previewDevice("iPhone 13 Pro Max")
            
            BasicUserInfoForm()
                .environmentObject(ProfileViewModel())
                .previewDisplayName("iPhone 12 Pro")
                .previewDevice("iPhone 12 Pro")
            
            BasicUserInfoForm()
                .environmentObject(ProfileViewModel())
                .previewDisplayName("iPhone 11")
                .previewDevice("iPhone 11")
        }
    }
}
