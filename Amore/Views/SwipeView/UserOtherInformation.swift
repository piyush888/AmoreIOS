//
//  UserOtherInformation.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/29/21.
//

import SwiftUI
import SwiftUIFontIcon
import WrappingStack


struct UserInfoData: View {
    @State var icon: Text
    @State var userInfoField: String

    var body : some View {

        HStack {
            Text("\(icon)")
            Text("\(userInfoField)")
                .font(.subheadline)
        }
        .padding(10)
           .background(
               Rectangle()
                   .stroke(Color.yellow)
                   .background(Color.yellow)
                   .cornerRadius(10.0)
                   .opacity(0.1)
           )

    }

}

struct UserOtherInformation: View {
    
    @State var iconNameUserDataList: [Text]
    @State var userInfoFieldData: [String]
    
    var body: some View {
        
        VStack {
            
            WrappingHStack(id: \.self, alignment: .leading, horizontalSpacing: 5, verticalSpacing: 5) {
                    
                ForEach(0..<iconNameUserDataList.count) { i in
                    
                    UserInfoData(icon: self.iconNameUserDataList[i],
                                 userInfoField:self.userInfoFieldData[i])
                }
            }
            
        }
    }
}

struct UserOtherInformation_Previews: PreviewProvider {
    static var previews: some View {
        UserOtherInformation(iconNameUserDataList:[FontIcon.text(.materialIcon(code: .child_care)),
                                                   FontIcon.text(.materialIcon(code: .smoking_rooms)),
                                                   FontIcon.text(.materialIcon(code: .fitness_center)),
                                                   FontIcon.text(.materialIcon(code: .school)),
                                                   FontIcon.text(.materialIcon(code: .local_bar)),
                                                   ],
                             userInfoFieldData:["Maybe",
                                                "Never",
                                                "Everyday",
                                                "Masters",
                                                "Occasionally",
                                                ]
                            )
    }
}
