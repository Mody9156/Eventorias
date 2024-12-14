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
    var dateCreation : Date
    var poster : String
    var description : String
    var hour : String
    var hourCreation : Date {
        Date.hourFromString(hour)
    }
    var category : String
    var place : Address
    
    enum CodingKeys: String, CodingKey {
        case id
        case picture
        case title
        case dateCreation = "dateCreationString"
        case poster
        case description
        case hour
        case category
        case place
    }
}

struct Place : Codable,Hashable {
    var address : Address
    
    enum CodingKeyForAddress : String, CodingKey {
        case address = "adress"
    }
}

struct Address : Codable,Hashable{
    var street: String
    var city: String
    var postalCode: String
    var country: String
    var localisation : GeoPoint
}

struct GeoPoint : Codable,Hashable {
    var latitude : Double
    var longitude : Double
}
