//
//  RegistrationViewModel.swift
//  Eventorias
//
//  Created by KEITA on 17/12/2024.
//

import Foundation
import PhotosUI

class AddEventViewModel : ObservableObject {
    let eventRepository: EventManagerProtocol
    
    init(eventRepository: EventManagerProtocol = EventRepository()) {
        self.eventRepository = eventRepository
    }
    
    func saveToFirestore(){
        
    }
}
