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
                                   
                    Text(eventEntry.dateString)
                        .foregroundColor(.white)
                    
                }
            }
        }
    }
}
//
//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView(eventEntry: EventEntry(picture: "MusicFestival", title: "Music festival", dateString: "June 15, 2024", poster: "ArtExhibitionPoster"))
//    }
//}
