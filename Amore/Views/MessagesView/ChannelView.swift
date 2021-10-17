//
//  ChannelView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import SwiftUI

struct ChannelView: View {
    
    @EnvironmentObject var streamModel: StreamViewModel
    
    var body: some View {
        VStack {
        // Message View...
        ScrollView(.vertical, showsIndicators: false, content: {
            
            VStack(spacing: 20){
                
                if let channels = streamModel.channels{
                    
                    ForEach(channels,id: \.channel){listner in
                        
                        NavigationLink(
                            destination: ChatView(listner: listner),
                            label: {
                                ChannelRowView(listner: listner)
                            })
                    }
                }
                else{
                    // Progress View....
                    ProgressView()
                        .padding(.top,20)
                }
            }
            .padding()
        })
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    streamModel.channels = nil
                    streamModel.fetchAllChannels()
                }, label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button(action: {
                    withAnimation{streamModel.createNewChannel.toggle()}
                }, label: {
                    Image(systemName: "square.and.pencil")
                })
            }
        })
        .onAppear(perform: {streamModel.fetchAllChannels()})
        .overlay(
            ZStack{
                
                
                // New Channel View....
                if streamModel.createNewChannel{CreateNewChannel()}
                
                // Lodaing Screen...
                if streamModel.isLoading{LoadingScreen()}
            }
        )
        }
        .navigationBarHidden(true)
        
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView()
    }
}
