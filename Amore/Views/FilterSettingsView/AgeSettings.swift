//
//  AgeSettings.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/19/21.
//

import SwiftUI



struct AgeSettings: View {
    
    @Binding var scaleMinAge: CGFloat
    @Binding var scaleMaxAge: CGFloat
    @Binding var realMinAge: String
    @Binding var realMaxAge: String
    
    var MaxPossibleAge = UIScreen.main.bounds.width - 60
    
    var body: some View {
        
            NavigationLink(
              destination: Slider(scaleMinAge: self.$scaleMinAge,
                                  scaleMaxAge: self.$scaleMaxAge,
                                  realMinAge: self.$realMinAge,
                                  realMaxAge: self.$realMaxAge,
                                  MaxPossibleAge: MaxPossibleAge),
              label: {
                  ZStack{
                  CommonContainer()
                  HStack {
                      
                      Text("Age")
                          .font(.subheadline)
                          .foregroundColor(Color.black)
                      
                      Spacer()
                      
                      Text("\(self.realMinAge) - \(self.realMaxAge)")
                  }
                  .padding(.horizontal,20)
              }
          })
    }
}

struct Slider : View {
    
    @Binding var scaleMinAge: CGFloat
    @Binding var scaleMaxAge: CGFloat
    @Binding var realMinAge: String
    @Binding var realMaxAge: String
    @State var MaxPossibleAge: CGFloat
    
    
    func RoundToString(val: CGFloat) -> String {
        return String(format : "%.0f", val)
    }
    
    var body : some View {

        VStack {
            
            Text("Age")
                .font(.title)
            
            Text("\(self.realMinAge) - \(self.realMaxAge)")
                .fontWeight(.bold)
                .padding(.top)
            
            ZStack(alignment: .leading) {
                
                Rectangle()
                    .fill(Color.black.opacity(0.20))
                    .frame(height:6)
                
                Rectangle()
                    .fill(Color.red)
                    .frame(width:self.scaleMaxAge - self.scaleMinAge, height: 6)
                    .offset(x:self.scaleMinAge + 18)
                
                HStack(spacing:0) {
                    
                    Circle()
                        .fill(Color.black)
                        .frame(width:18, height:18)
                        .offset(x:self.scaleMinAge)
                        .gesture(
                            DragGesture()
                                .onChanged({ (value) in
                                    if value.location.x >= (0.18 * self.MaxPossibleAge) && value.location.x <= self.scaleMaxAge {
                                        self.scaleMinAge = value.location.x
                                        self.realMinAge = RoundToString(val: self.scaleMinAge/self.MaxPossibleAge * 100)
                                    }
                                })
                        )
                    
                    Circle()
                        .fill(Color.black)
                        .frame(width:18, height:18)
                        .offset(x:self.scaleMaxAge)
                        .gesture(
                            DragGesture()
                                .onChanged({ (value) in
                                    if value.location.x >= self.scaleMinAge && value.location.x <= (0.61 * self.MaxPossibleAge) {
                                        self.scaleMaxAge = value.location.x
                                        self.realMaxAge = RoundToString(val: self.scaleMaxAge/self.MaxPossibleAge * 100)
                                    }
                                })
                        )
                }
            }
                .padding()
            
            Spacer()
            
            }
        }
        
    
}


