//
//  UserDetailView.swift
//  Eventorias
//
//  Created by KEITA on 01/12/2024.
//

import SwiftUI

struct UserDetailView: View {
    let eventEntry : EventEntry
    var body: some View {
        VStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                VStack {
                    Image(eventEntry.poster)
                        .resizable()
                        .frame(width: 358, height: 364)
                    Text(eventEntry.dateString)
                        .foregroundColor(.white)
                    
                    
                }.navigationTitle(eventEntry.title)
            }
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(eventEntry: EventEntry(picture: "MusicFestival", title: "Music festival", dateString: "June 15, 2024", poster: "ArtExhibitionPoster"))
    }
}
