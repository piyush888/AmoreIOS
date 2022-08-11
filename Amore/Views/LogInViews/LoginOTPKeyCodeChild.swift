//
//  OTPKeyCode.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/25/21.
//

import SwiftUI

struct LoginOTPKeyCodeChild: View {
    
    @EnvironmentObject var otpViewModel: OTPViewModel
    
//    @Binding var otpVerificationCode: String
    @State var isFocused = false
  
    let textBoxWidth = UIScreen.main.bounds.width / 10
    let textBoxHeight = UIScreen.main.bounds.width / 8
    let spaceBetweenBoxes: CGFloat = 10
    let paddingOfBox: CGFloat = 1
    var textFieldOriginalWidth: CGFloat {
        (textBoxWidth*6)+(spaceBetweenBoxes*3)+((paddingOfBox*2)*3)
    }
    
    
    var body: some View {
        VStack {
              ZStack {
                  
                  HStack (spacing: spaceBetweenBoxes){
                      
                      otpText(text: otpViewModel.otp1)
                      otpText(text: otpViewModel.otp2)
                      otpText(text: otpViewModel.otp3)
                      otpText(text: otpViewModel.otp4)
                      otpText(text: otpViewModel.otp5)
                      otpText(text: otpViewModel.otp6)
                  }
                  
                  
                  TextField("", text: $otpViewModel.otpField)
                  .frame(height: textBoxHeight)
                  .disabled(otpViewModel.isTextFieldDisabled)
                  .textContentType(.oneTimeCode)
                  .foregroundColor(.clear)
                  .accentColor(.clear)
                  .background(Color.clear)
                  .keyboardType(.numberPad)
                
              }
      }

    }
    
    private func otpText(text: String) -> some View {
//              otpViewModel.otpVerificationCode = $otpVerificationCode
              return Text(text)
                  .font(.title)
                  .foregroundColor(.pink)
                  .frame(width: textBoxWidth, height: textBoxHeight)
                  .background(VStack{
                    Spacer()
                    RoundedRectangle(cornerRadius: 1)
                        .frame(height: 0.5)
                        .foregroundColor(.pink)
                        .background(Color.pink)
                   })
                  .padding(paddingOfBox)
          }
    
}

struct NumberCode2_Previews: PreviewProvider {
    static var previews: some View {
        LoginOTPKeyCodeChild()
            .environmentObject(OTPViewModel())
    }
}
