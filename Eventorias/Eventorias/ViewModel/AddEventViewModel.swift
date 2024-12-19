//
//  RegistrationViewModel.swift
//  Eventorias
//
//  Created by KEITA on 17/12/2024.
//

import Foundation
import PhotosUI
import CoreLocation

class AddEventViewModel : ObservableObject {
    let eventRepository: EventManagerProtocol
    @Published private var errorMessage: String?
    @Published private var coordinates : CLLocationCoordinate2D?
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
    func geocodeAddress(address:String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address){ placemarks, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.coordinates = nil
            }else if let placemark = placemarks?.first, let location = placemark.location {
                self.coordinates = location.coordinate
                self.errorMessage = nil
            }else{
                self.errorMessage = "Adresse introuvable"
                self.coordinates = nil
            }
        }
    }
    
    func saveImageToTemporaryDirectory(image:UIImage, fileName:String) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("Erreur : impossible de convertir l'image.")
            return nil
        }
        
        let tempDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do{
            try data.write(to: fileURL)
            print("Chemin temporaire : \(fileURL.path)")

            return fileURL.path
            
        }catch{
            print("Erreur \(error)")
            return nil
        }
    }
}
