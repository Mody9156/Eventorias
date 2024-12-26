//
//  EventRepositoryTests.swift
//  Eventorias
//
//  Created by KEITA on 26/12/2024.
//

import XCTest
import Firebase
import FirebaseAuth
import FirebaseCore
final class EventRepositoryTests: XCTestCase {


    func testSaveToFirestoreSuccess()  {
        
    }

}
  
//var array =  EventEntry(id: "lkdgniezgre5655", picture: "Music", title: "Man of the Moon", dateCreation: Date.now, poster: "MonnPoster", description: "Once up on time", hour: "11:33", category: "Music", place: Address(street: "2 Rue du Vieux Château", city: "Crosne", postalCode: "91560", country: "France", localisation: GeoPoint(latitude: 48.71733474731445, longitude: 2.4710028171539307)))
extension EventManagerProtocol {
    func saveToFirestore(_ event: EventEntry,completion:@escaping(Bool,Error?)-> Void ){
        
    }
}
