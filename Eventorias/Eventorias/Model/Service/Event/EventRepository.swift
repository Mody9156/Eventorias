//
//  EventRepository.swift
//  Eventorias
//
//  Created by KEITA on 17/12/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public class EventRepository : ObservableObject,EventManagerProtocol{
    var db = FirestoreCollectionProtocol
    var db = Firestore.firestore().collection("eventorias")
    
    func saveToFirestore(_ event: EventEntry,completion:@escaping(Bool,Error?)-> Void ){
        
        do {
            let encodedEvent = try Firestore.Encoder().encode(event)
            
            db.addDocument(data: encodedEvent) { error in
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        } catch let encodingError {
            completion(false, encodingError)
        }
    }
}
