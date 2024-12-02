//
//  EventoriasRepository.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation


public class EventoriasRepository : ObservableObject {
    
    @Published
    var eventEntry = [EventEntry]()
    
}
