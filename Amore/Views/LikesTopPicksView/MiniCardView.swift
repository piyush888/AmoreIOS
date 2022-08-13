//
//  MiniCardView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/18/21.
//

import SwiftUI

struct MiniCardView: View {
    
    @Binding var singleProfile: CardProfileWithPhotos
    var animation: Namespace.ID
    @State var geometry: GeometryProxy
    @State var miniCardWidth: CGFloat
    @State var miniCardHeight: CGFloat
    
    var body: some View {
        
            VStack {
                    
                if self.singleProfile.image1?.imageURL != nil  {
                    
                    ZStack {
                        if self.singleProfile.image1?.imageURL != nil  {
                            CardImages(profileImage: $singleProfile.image1,
                                       photoStruct: $singleProfile.photo1.boundPhoto,
                                       width:miniCardWidth,
                                       height:miniCardHeight)
                                    .matchedGeometryEffect(id: "image\(singleProfile.id.bound)", in: animation)
                                    .cornerRadius(10)
                                    
                            VStack {
                                Spacer()
                                HStack {
                                    VStack(alignment:.leading, spacing:0)  {
                                        HStack {
                                            Text("\(singleProfile.firstName.bound)")
                                                .font(.caption)
                                                .bold()
                                            
                                            Text("\(singleProfile.age.boundInt)")
                                                .font(.caption2)
                                                .fontWeight(.light)
                                        }
                                    }
                                    .padding(.horizontal,10)
                                    .padding(.vertical,3)
                                    .foregroundColor(.white)
                                    Spacer()
                                }
                                    
                            }
                        }
                    }
                    
                }
                else {
                    Image(systemName: "camera.fill")
                        .onTapGesture {
                            print("ID for faulting profile: ", singleProfile.id)
                        }
                }
                
            }
//            .background(
//                Color(singleProfile.photo1.downsampledImage)
//                    .matchedGeometryEffect(id: "color\(singleProfile.id.bound)", in: animation)
//            )
            
    }
}

