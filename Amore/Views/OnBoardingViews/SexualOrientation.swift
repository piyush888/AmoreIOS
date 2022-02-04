//
//  SexualOrientation.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/29/21.
//

import SwiftUI

struct SexualOrientation: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
//    @EnvironmentObject var streamModel: StreamViewModel
    
    var selectionOrientationList = ["Straight","Gay","Lesbian","Bisexual",
                                    "Asexual","Demisexual","Pansexual",
                                    "Queer","Questioning"]
    
    @State var orientationsSelected = [String]()
    @State var showMyOrientation: Bool = false
    @State var sexualOrientationDataTaken: Bool = false
    
    func checkInputDone () {
        if (orientationsSelected.count > 0) {
            sexualOrientationDataTaken = true
            addInputToProfile()
        }
        else {
            sexualOrientationDataTaken = false
        }
    }
    
    func addInputToProfile () {
        profileModel.userProfile.sexualOrientation = orientationsSelected
        profileModel.userProfile.sexualOrientationVisible = showMyOrientation
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
//            HStack {
//                Text("My Sexual Orientation")
//                    .font(.BoardingTitle)
//                    .padding(.bottom, 10)
//                Spacer()
//            }
            
            HStack {
                Text("Select up to 3")
                    .font(.BoardingSubHeading)
                    .padding(.bottom, 10)
                Spacer()
            }.padding(.bottom, 30)
            
            
            // LazyVGrid
            ForEach(selectionOrientationList, id: \.self) { item in
                
                let orientationChoosen = orientationsSelected.contains("\(item)")
                
                Button(action: {
                    // Add/Remove to passionSelected
                    if orientationsSelected.contains("\(item)") {
                        // Remove if button clicked again
                        if let index = orientationsSelected.firstIndex(of: item) {
                            orientationsSelected.remove(at: index)
                        }
                    } else if(orientationsSelected.count < 3) {
                        // Add if passion doesn't exist in list
                        orientationsSelected.append(item)
                    }
                    print(orientationsSelected)
                    print(showMyOrientation)
                    // Load the passionSelected to firebase
                }) {
                    ZStack {
                        Text("\(item)")
                            .foregroundColor(orientationChoosen == true ? .black : .pink)
                            .bold()
                            .font(.BoardingSubHeading)
                            .padding(.bottom, 10)
                    }
                }
            }
            
            Spacer()
            
            // Ask user if they want to show the orientation on profile
            Toggle(isOn: $showMyOrientation, label: {
                Text("Show my orientation on my profile")
                    .foregroundColor(.gray)
                    .font(.system(size: 15, design: .default))
            })
            .padding()
            .toggleStyle(CheckboxStyle())
            
            // Continue to next view
            NavigationLink(destination: ShowMe()
                            .environmentObject(profileModel),
//                            .environmentObject(streamModel),
                           isActive: $sexualOrientationDataTaken,
                           label: {
                Button{
                    checkInputDone()
                } label : {
                    ZStack{
                        Rectangle()
                            .frame(height:45)
                            .cornerRadius(5.0)
                            .foregroundColor(.pink)
                        
                        Text("Continue")
                            .foregroundColor(.white)
                            .bold()
                            .font(.BoardingButton)
                    }
                }.padding(.bottom, 10)
            })

        }
        .padding(20)
        .navigationBarTitle("My Sexual Orientation")
    }
}

struct CheckboxStyle: ToggleStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        return HStack {
            
            configuration.label
            
            Spacer()
            
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(.gray)
                .font(.system(size: 15, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
        
    }
}

struct SexualOrientation_Previews: PreviewProvider {
    static var previews: some View {
        SexualOrientation()
            .environmentObject(ProfileViewModel())
    }
}
