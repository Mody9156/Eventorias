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
    
    func saveToFirestore(_ event : EventEntry){
        var event  = EventEntry(picture: <#T##String#>, title: <#T##String#>, dateCreation: <#T##Date#>, poster: <#T##String#>, description: <#T##String#>, hour: <#T##String#>, category: <#T##String#>, place: <#T##Address#>)
        eventRepository.saveToFirestore(event) { success, error in
            if success {
                print("L'évènement a été sauvegardé avec succès.")
            }else{
                print("Erreur, \(error?.localizedDescription ?? "Inconnue")")
            }
        }
    }
}
