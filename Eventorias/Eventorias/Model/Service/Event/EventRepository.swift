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
    var db = Firestore.firestore().collection("eventorias")
    
    func saveToFirestore(_ event: EventEntry,completion:@escaping(Bool,Error?)-> Void ){
      
        do {
            let encodedEvent = try Firestore.Encoder().encode(event)
                
             db.addDocument(data: encodedEvent) { error in
                    if let error = error {
                        print("Erreur lors de l'enregistrement de l'événement : \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        print("Événement ajouté avec succès dans Firestore !")
                        completion(true, nil)
                    }
                }
            } catch let encodingError {
                print("Erreur d'encodage : \(encodingError.localizedDescription)")
                completion(false, encodingError)
            }
    }
}
