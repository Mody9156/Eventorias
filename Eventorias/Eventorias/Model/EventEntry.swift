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
       Date.dateFromString(dateCreationString)
    }
    var poster : String
    var description : String
    var hour : String
    var hourCreation : Date {
        Date.dateFromString(hour) ?? Date.now

    }
}

extension EventEntry {
    static let eventEntry  = [
        EventEntry(picture: "MusicFestival", title: "Music festival", dateCreationString:"2024-06-15T12:00:00Z"
, poster: "MusicFestivalPoster",description:"",hour:""),
        EventEntry(picture: "ArtExhibition", title: "Art exhibition", dateCreationString: "2024-06-20T12:00:00Z", poster: "ArtExhibitionPoster",description:"",hour:""),
        EventEntry(picture: "TechConference", title: "Tech conference", dateCreationString: "2024-08-05T12:00:00Z", poster: "TechConferencePoster",description:"",hour:""),
        EventEntry(picture: "FoodFaire", title: "Food fair", dateCreationString: "2024-09-12T12:00:00Z", poster: "FoodFairePoster",description:"",hour:""),
        EventEntry(picture: "BookSigning", title: "Book signing", dateCreationString: "2024-10-30T12:00:00Z", poster: "BookSigningPoster",description:"",hour:""),
        EventEntry(picture: "FilmScreening", title: "Book signing", dateCreationString: "2024-11-10T12:00:00Z", poster: "FilmScreeningPoster",description:"",hour:""),
        EventEntry(picture: "CharityRun", title: "Charity run", dateCreationString: "2024-10-10T12:00:00Z", poster: "CharityRunPoster",description:"",hour:"")
    ]
}
