//
//  AgeSettings.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/19/21.
//

import SwiftUI

struct AgeSettings: View {
    
    @Binding var minAge: CGFloat
    @Binding var maxAge: CGFloat
    
    var body: some View {
        
        ZStack{
            
            CommonContainer()
        
            VStack {
                
                Text("Age")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    
                Spacer()
                
                Text("\(self.minAge) - \(self.maxAge)")
                
                Slider(minAge: self.$minAge, maxAge: self.$maxAge)
                
            }.padding(.horizontal,20)
        }
        
    }
}

struct Slider : View {
    
    @Binding var minAge: CGFloat
    @Binding var maxAge: CGFloat
    
    var MaxPossibleAge = UIScreen.main.bounds.width - 60
    
    func RoundToString(val: CGFloat) -> String {
        return String(format : "%.0f", val*100)
    }
    
    
    var body : some View {

        
    VStack {
        
        Text("\(self.RoundToString(val:self.minAge / self.MaxPossibleAge)) - \(self.RoundToString(val:self.maxAge / self.MaxPossibleAge))")

            .fontWeight(.bold)
            .padding(.top)
        
        
        ZStack(alignment: .leading) {
            
            Rectangle()
                .fill(Color.black.opacity(0.20))
                .frame(height:6)
            
            Rectangle()
                .fill(Color.black)
                .frame(width:self.maxAge - self.minAge, height: 6)
                .offset(x:self.minAge + 18)
            
            HStack(spacing:0) {
                
                Circle()
                    .fill(Color.black)
                    .frame(width:18, height:18)
                    .offset(x:self.minAge)
                    .gesture(
                        DragGesture()
                            .onChanged({ (value) in
                                if value.location.x >= 0 && value.location.x <= self.maxAge {
                                    self.minAge = value.location.x
                                }
                            })
                    )
                
                Circle()
                    .fill(Color.black)
                    .frame(width:18, height:18)
                    .offset(x:self.maxAge)
                    .gesture(
                        DragGesture()
                            .onChanged({ (value) in
                                if value.location.x <= self.MaxPossibleAge && value.location.x >= self.maxAge {
                                    self.maxAge = value.location.x
                                }
                            })
                    )
            }
        }
        .padding(.top,25)
        }
    }
    
    
}

struct AgeSettings_Previews: PreviewProvider {
    static var previews: some View {
        AgeSettings(minAge: Binding.constant(20), maxAge: Binding.constant(30))
    }
}
