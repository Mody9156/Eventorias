//
//  EventManagerProtocol.swift
//  Eventorias
//
//  Created by KEITA on 18/12/2024.
//

import Foundation

protocol EventManagerProtocol {
    func saveToFirestore(_ event: EventEntry,completion:@escaping(Bool,Error?)-> Void )
}

