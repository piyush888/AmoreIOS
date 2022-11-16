//
//  AgeSettings2.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/22/21.
//

import SwiftUI


struct AgeSettings: View {
    
    @Binding var minAgeFilter: Int
    @Binding var maxAgeFilter: Int
    
    var body: some View {
        
            NavigationLink(
              destination: ShowAge(minAgeFilter:$minAgeFilter,
                                   maxAgeFilter:$maxAgeFilter),
              label: {
                  FilterCommonContainer(filterName:"Age",
                                        filteredValue:"Modify")
              })
        }
}


struct ShowAge: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showingAlert = false
    @ObservedObject var slider: CustomSlider = CustomSlider(start: 18.0, end: 60.0, lhSP:0.0, hHSP:1.0)
    
    @Binding var minAgeFilter: Int
    @Binding var maxAgeFilter: Int
    
    var lhSP:Double = 0.0
    var hHSP:Double = 1.0
    
    init(minAgeFilter:Binding<Int>, maxAgeFilter:Binding<Int>){
        self._minAgeFilter = minAgeFilter
        self._maxAgeFilter = maxAgeFilter
        // lhsp Pct % * (Max Age - Min Age) + Min Age = minAgeFilter
        // hHSP Pct % * (Max Age - Min Age) + Min Age = maxAgeFilter
        self.lhSP = (Double(self.minAgeFilter) - 18.0)/42.0
        self.hHSP = (Double(self.maxAgeFilter) - 18.0)/42.0
        self.slider = CustomSlider(start: 18.0, end: 60.0, lhSP:self.lhSP, hHSP:self.hHSP)
    }
    
    var body: some View {
        
        Group {
            Spacer()
            HStack {
                Text("Min Age \(Int(self.slider.lowHandle.currentValue))")
                Spacer()
                Text("Max Age \(Int(self.slider.highHandle.currentValue))")
            }
            .padding()
            
            SliderView(slider: self.slider)
            Spacer()
        }
        .foregroundColor(.accentColor)
        .onChange(of: self.slider.lowHandle.currentValue, perform: { newValue in
            let newAgeFilter = Int(newValue)
            if newAgeFilter >= self.maxAgeFilter {
                self.showingAlert = true
                // Revert to original value before dragging
                self.slider.lowHandleStartPercentage = 0.20
            } else {
                self.minAgeFilter = newAgeFilter
            }
        })
        .onChange(of: self.slider.highHandle.currentValue, perform: { newValue in
            let newAgeFilter = Int(newValue)
            if newAgeFilter <= self.minAgeFilter {
                self.showingAlert = true
                // Revert to original value before dragging
                self.slider.highHandleStartPercentage = 0.80
            } else {
                self.maxAgeFilter = newAgeFilter
            }
        })
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Incorrect range"),
                  message: Text("Min age should be less than max age."),
                  dismissButton: .default(Text("OK"))
            )
        }
        .navigationTitle("Age Preference")
            
    }
}


struct SliderView: View {
    @ObservedObject var slider: CustomSlider
    
    var body: some View {
        RoundedRectangle(cornerRadius: slider.lineWidth)
            .fill(Color.gray.opacity(0.2))
            .frame(width: slider.width, height: slider.lineWidth)
            .overlay(
                ZStack {
                    //Path between both handles
                    SliderPathBetweenView(slider: slider)
                    
                    //Low Handle
                    SliderHandleView(handle: slider.lowHandle)
                        .highPriorityGesture(slider.lowHandle.sliderDragGesture)
                    
                    //High Handle
                    SliderHandleView(handle: slider.highHandle)
                        .highPriorityGesture(slider.highHandle.sliderDragGesture)
                }
            )
    }
}

struct SliderHandleView: View {
    @ObservedObject var handle: SliderHandle
    
    var body: some View {
        Circle()
            .frame(width: handle.diameter, height: handle.diameter)
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 0)
            .scaleEffect(handle.onDrag ? 1.3 : 1)
            .contentShape(Rectangle())
            .position(x: handle.currentLocation.x, y: handle.currentLocation.y)
    }
}

struct SliderPathBetweenView: View {
    @ObservedObject var slider: CustomSlider
    
    var body: some View {
        Path { path in
            path.move(to: slider.lowHandle.currentLocation)
            path.addLine(to: slider.highHandle.currentLocation)
        }
        .stroke(Color.green, lineWidth: slider.lineWidth)
    }
}


