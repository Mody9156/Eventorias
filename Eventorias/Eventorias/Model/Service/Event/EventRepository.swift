//
//  EventRepository.swift
//  Eventorias
//
//  Created by KEITA on 17/12/2024.
//

import Foundation

public class EventRepository : ObservableObject{
    var db = Firestore.firestore().collection("eventorias")
    
    func addNewEvent()async throws -> [EventEntry] {
        
    }
}
