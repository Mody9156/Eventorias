//
//  EventRepository.swift
//  Eventorias
//
//  Created by KEITA on 17/12/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
public class EventRepository: ObservableObject, EventManagerProtocol {
    // Remplacer FirestoreCollectionProtocol par CollectionReference directement
    var db: CollectionReference

    // Initialisation avec une référence à la collection "eventorias"
    init(db: CollectionReference = Firestore.firestore().collection("eventorias")) {
        self.db = db
    }

    func saveToFirestore(_ event: EventEntry, completion: @escaping (Bool, Error?) -> Void) {
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
