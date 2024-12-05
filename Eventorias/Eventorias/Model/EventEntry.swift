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
        Date.hourFromString(hour) 
    }
    var category : String
    var place : Adress
    
  
}

struct Adress : Codable,Hashable{
    var street: String
    var city: String
    var posttalCode: String
    var country: String
}

extension EventEntry {
    static let eventEntry  = [
        EventEntry(picture: "MusicFestival", title: "Music festival", dateCreationString:"2024-06-15T12:00:00Z"
                   , poster: "MusicFestivalPoster",description:"Join us for an unforgettable Music Festival celebrating the vibrant sounds of today's most talented artists. This event will feature an exciting lineup of performances, ranging from electrifying live bands to soulful solo acts, offering a diverse and immersive musical experience. Whether you're a devoted music enthusiast or simply looking for a weekend of fun, you'll have the chance to enjoy an eclectic mix of genres and discover emerging talent. Don't miss this opportunity to connect with fellow music lovers and create lasting memories in an energetic, festival atmosphere!",hour:"2024-06-15T12:00:00Z", category: "Music",place: Adress(street: "81-800 Avenue 51", city: "Indio", posttalCode: "92201", country: "USA")),
        EventEntry(picture: "ArtExhibition", title: "Art exhibition", dateCreationString: "2024-06-20T12:00:00Z", poster: "ArtExhibitionPoster",description:"Join us for an exclusive Art Exhibition showcasing the works of the talented artist Emily Johnson. This exhibition will feature a captivating collection of her contemporary and classical pieces, offering a unique insight into her creative journey. Whether you're an art enthusiast or a casual visitor, you'll have the chance to explore a diverse range of artworks.",hour:"2024-06-20T14:50:00Z", category: "Exhibition", place: Adress(street: "Rue de Rivoli", city: "Paris", posttalCode: "75001", country: "France")),
        EventEntry(picture: "TechConference", title: "Tech conference", dateCreationString: "2024-08-05T12:00:00Z", poster: "TechConferencePoster",description:"Join us for an exclusive Tech Conference showcasing the latest innovations and breakthroughs in technology. This conference will feature a dynamic lineup of keynote speakers, interactive workshops, and cutting-edge product demonstrations, offering a unique opportunity to explore the forefront of technological advancement. Whether you're a seasoned professional, an entrepreneur, or simply curious about the future of tech, you'll have the chance to connect with industry leaders, gain valuable insights, and expand your network. Don’t miss this opportunity to be part of a transformative experience that shapes the future of innovation!",hour:"2024-08-05T02:30:00Z", category: "Conference", place: Adress(street: "300 W San Carlos St", city: "San Jose", posttalCode: "95110", country: "USA")),
        EventEntry(picture: "FoodFaire", title: "Food fair", dateCreationString: "2024-09-12T12:00:00Z", poster: "FoodFairePoster",description:"Join us for an extraordinary Food Fair celebrating the flavors of the world! This event will feature a mouthwatering selection of culinary delights, from gourmet dishes to street food favorites, offering a unique journey through diverse cuisines. Whether you're a passionate foodie or just looking for a fun day out, you'll have the chance to savor delicious bites, attend cooking demonstrations by renowned chefs, and discover exciting new flavors. Don’t miss this opportunity to indulge in a feast for your senses and connect with fellow food enthusiasts in a vibrant, festive atmosphere!",hour:"2024-09-12T10:30:00Z", category: "Food", place: Adress(street: "90 Kent Ave", city: "Brooklyn", posttalCode: "11249", country: "USA")),
        EventEntry(picture: "BookSigning", title: "Book signing", dateCreationString: "2024-10-30T12:00:00Z", poster: "BookSigningPoster",description:"Join us for an exclusive Book Signing event with the acclaimed author [Author's Name]! This event will feature a personal meet-and-greet with the author, who will be signing copies of their latest book, [Book Title]. Whether you're a long-time fan or discovering their work for the first time, this is a unique opportunity to engage with the author, ask questions, and delve deeper into their creative process. Don’t miss the chance to take home a signed copy of Whispers of the Forgotten and be part of an unforgettable literary experience!",hour:"2024-10-30T08:10:00Z", category: "Book", place: Adress(street: "828 Broadway", city: "New York", posttalCode: "10003", country: "USA")),
        EventEntry(picture: "FilmScreening", title: "Book signing", dateCreationString: "2024-11-10T12:00:00Z", poster: "FilmScreeningPoster",description:"Join us for an exclusive Film Screening of [Film Title], a captivating cinematic experience that you won't want to miss! This event will feature a special screening of the critically acclaimed Echoes of the Past, followed by a live Q&A with the director and cast. Whether you're a film enthusiast or simply looking for an entertaining night out, this is your chance to dive into the world of filmmaking, discover behind-the-scenes stories, and engage with the creative minds behind the film. Don’t miss out on this unique opportunity to enjoy a memorable movie night and connect with fellow movie lovers!",hour:"2024-11-10T02:20:00Z", category: "Film", place: Adress(street: "6925 Hollywood Blvd", city: "Los Angeles", posttalCode: "90028", country: "USA")),
        EventEntry(picture: "CharityRun", title: "Charity run", dateCreationString: "2024-10-10T12:00:00Z", poster: "CharityRunPoster",description:"Join us for the Run for a Cause 2024 Charity Run, a fun and impactful way to give back to the community! This event will feature a scenic route suitable for all levels, from casual walkers to seasoned runners. Whether you're participating to challenge yourself or simply to support a good cause, your participation will help raise vital funds for [Cause/Organization Name]. After the run, enjoy post-race celebrations with music, refreshments, and community activities. Don’t miss the chance to make a difference while getting active and connecting with others who share your passion for helping others!",hour:"2024-10-10T12:50:00Z", category: "Charity", place: Adress(street: "Start at Staten Island", city: "New York", posttalCode: "10301", country: "USA"))
    ]
}
