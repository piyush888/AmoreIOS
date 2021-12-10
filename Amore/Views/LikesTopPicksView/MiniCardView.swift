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
    @EnvironmentObject var cardProfileModel: CardProfileModel
    
    
    var body: some View {
        
            VStack {
                    
                if self.singleProfile.image1?.imageURL != nil  {
                    
                    ZStack {
                        if self.singleProfile.image1?.imageURL != nil  {
                            CardImages(profileImage: $singleProfile.image1,
                                       photoStruct: $singleProfile.photo1.boundPhoto,
                                       width:geometry.size.width/2.2,
                                       height:geometry.size.height/3,
                                       testing:false)
                                    .matchedGeometryEffect(id: "image\(singleProfile.id.bound)", in: animation)
                                    .cornerRadius(10)
                                    
                            VStack {
                                Spacer()
                                HStack {
                                    VStack(alignment:.leading, spacing:0)  {
                                        HStack {
                                            Text("\(singleProfile.firstName.bound)")
                                                .font(.headline)
                                                .bold()
                                            
                                            Text("\(singleProfile.age.boundInt)")
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
                
            }
//            .background(
//                Color(singleProfile.photo1.downsampledImage)
//                    .matchedGeometryEffect(id: "color\(singleProfile.id.bound)", in: animation)
//            )
            
    }
}

