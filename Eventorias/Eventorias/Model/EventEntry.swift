//
//  EventEntry.swift
//  Eventorias
//
//  Created by KEITA on 27/11/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct EventEntry : Identifiable, Codable{
    @DocumentID // lier automatiquement un champ d'une structure à l'ID d'un document Firestore.
    var id : String?
    var picture : String
    var title : String
    var dateString : String
    var poster : String
    
}

extension EventEntry {
    static let eventEntry  = [
        EventEntry(picture: "MusicFestival", title: "Music festival", dateString: "June 15, 2024", poster: "MusicFestivalPoster"),
        EventEntry(picture: "ArtExhibition", title: "Art exhibition", dateString: "July 20, 2024", poster: "ArtExhibitionPoster"),
        EventEntry(picture: "TechConference", title: "Tech conference", dateString: "August 5, 2024", poster: "TechConferencePoster")
    ]
}
