//
//  EventEntry.swift
//  Eventorias
//
//  Created by KEITA on 27/11/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct EventEntry : Identifiable, Codable,Hashable{
    @DocumentID
    var id :String?
    var picture : String
    var title : String
    var dateCreationString : String
    var dateCreation : Date {
        Date.dateFromString(dateCreationString) ?? Date.now
        
    }
    var poster : String
}

extension EventEntry {
    static let eventEntry  = [
        EventEntry(picture: "MusicFestival", title: "Music festival", dateCreationString: "June 15, 2024", poster: "MusicFestivalPoster"),
        EventEntry(picture: "ArtExhibition", title: "Art exhibition", dateCreationString: "July 20, 2024", poster: "ArtExhibitionPoster"),
        EventEntry(picture: "TechConference", title: "Tech conference", dateCreationString: "August 5, 2024", poster: "TechConferencePoster")
    ]
}
