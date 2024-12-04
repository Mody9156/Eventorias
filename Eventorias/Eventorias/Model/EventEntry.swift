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
    Date.dateFromString(dateCreationString) ??  Date.now
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
        EventEntry(picture: "MusicFestival", title: "Music festival", dateCreationString: "June-15,-15T12:00:00Z", poster: "MusicFestivalPoster",description:"",hour:""),
        EventEntry(picture: "ArtExhibition", title: "Art exhibition", dateCreationString: "July 20, 2024", poster: "ArtExhibitionPoster",description:"",hour:""),
        EventEntry(picture: "TechConference", title: "Tech conference", dateCreationString: "August 5, 2024", poster: "TechConferencePoster",description:"",hour:""),
        EventEntry(picture: "FoodFaire", title: "Food fair", dateCreationString: "September 12, 2024", poster: "FoodFairePoster",description:"",hour:""),
        EventEntry(picture: "BookSigning", title: "Book signing", dateCreationString: "October 3, 2024", poster: "BookSigningPoster",description:"",hour:""),
        EventEntry(picture: "FilmScreening", title: "Book signing", dateCreationString: "November 10, 2024", poster: "FilmScreeningPoster",description:"",hour:""),
        EventEntry(picture: "CharityRun", title: "Charity run", dateCreationString: "Octobre 10, 2024", poster: "CharityRunPoster",description:"",hour:"")
    ]
}
