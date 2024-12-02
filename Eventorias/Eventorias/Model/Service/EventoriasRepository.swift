//
//  EventoriasRepository.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public class EventoriasRepository : ObservableObject {
    
    @Published
    var eventEntry = [EventEntry]()
    
    func addEvenement(_ eventEntry:EventEntry ) throws {
       try Firestore
            .firestore()
            .collection("eventorias")
            .addDocument(from: eventEntry)
    }
}
