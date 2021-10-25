//
//  UserProfilePhotosView.swift
//  Amore
//
//  Created by Piyush Garg on 18/10/21.
//

import SwiftUI
import CoreMedia
import SDWebImageSwiftUI
import Firebase

struct UserProfilePhotosView: View {
    let adaptivecolumns = Array(repeating:
                                    GridItem(.adaptive(minimum: 150),spacing: 5,
                                             alignment: .center),count: 3)
    
    @EnvironmentObject var photoModel: PhotoModel
    
    var body: some View {
        // Give the user options to add photos
        GeometryReader { geometry in
            ScrollView {
                let side = geometry.size.width / 4
                let item = GridItem(.fixed(side), spacing: 2)
                LazyVGrid(columns: Array(repeating: item, count: 3), spacing: 2) {
                    ForEach(photoModel.downloadedPhotosURLs.indices, id: \.self) {
                        WebImage(url: photoModel.downloadedPhotosURLs[$0].imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
//                            .frame(width: side, height: side)
//                            .clipped()
                    }
                }
            }
            .frame(minWidth: geometry.size.width, idealWidth: geometry.size.width, maxWidth: geometry.size.width, minHeight: geometry.size.height/2, idealHeight: geometry.size.height/2, maxHeight: geometry.size.height/2, alignment: .center)
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
    }
}


struct UserProfilePhotosView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfilePhotosView()
    }
}
