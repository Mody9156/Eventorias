//
//  RegistrationViewModel.swift
//  Eventorias
//
//  Created by KEITA on 17/12/2024.
//

import Foundation
import PhotosUI

class AddEventViewModel : ObservableObject {
    @Published var picture : String = ""
    let eventRepository: EventManagerProtocol
    
    init(eventRepository: EventManagerProtocol = EventRepository()) {
        self.eventRepository = eventRepository
    }
    
    func saveToFirestore(picture: String, title: String, dateCreation: Date, poster: String, description: String, hour: String, category: String, street: String, city: String, postalCode: String, country: String, latitude: Double, longitude: Double  ){
        
        var  geoPoint =  GeoPoint(latitude: latitude, longitude: longitude)
        
        var adresse = Address(street: street, city: city, postalCode: postalCode, country: country, localisation: geoPoint)
        
        var event  = EventEntry(picture: picture, title: title, dateCreation: dateCreation, poster: poster, description: description, hour: hour, category: category, place: adresse )
        
        eventRepository.saveToFirestore(event) { success, error in
            if success {
                print("L'évènement a été sauvegardé avec succès.")
            }else{
                print("Erreur, \(error?.localizedDescription ?? "Inconnue")")
            }
        }
    }
}
