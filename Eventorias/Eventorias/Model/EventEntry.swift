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
        Date.dateFromString(hour) 

    }
}

extension EventEntry {
    static let eventEntry  = [
        EventEntry(picture: "MusicFestival", title: "Music festival", dateCreationString:"20240615T120000Z"
, poster: "MusicFestivalPoster",description:"",hour:""),
        EventEntry(picture: "ArtExhibition", title: "Art exhibition", dateCreationString: "20240620T120000Z", poster: "ArtExhibitionPoster",description:"",hour:""),
        EventEntry(picture: "TechConference", title: "Tech conference", dateCreationString: "20240805T120000Z", poster: "TechConferencePoster",description:"",hour:""),
        EventEntry(picture: "FoodFaire", title: "Food fair", dateCreationString: "20240912T120000Z", poster: "FoodFairePoster",description:"",hour:""),
        EventEntry(picture: "BookSigning", title: "Book signing", dateCreationString: "20241030T120000Z", poster: "BookSigningPoster",description:"",hour:""),
        EventEntry(picture: "FilmScreening", title: "Book signing", dateCreationString: "20241110T120000Z", poster: "FilmScreeningPoster",description:"",hour:""),
        EventEntry(picture: "CharityRun", title: "Charity run", dateCreationString: "20241010T120000Z", poster: "CharityRunPoster",description:"",hour:"")
    ]
}
