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
    @Published
     var errorMessage: String?
    @Published
    var coordinates : CLLocationCoordinate2D?
    
    init(eventRepository: EventManagerProtocol = EventRepository(), coordinates : CLLocationCoordinate2D?) {
        self.eventRepository = eventRepository
        self.coordinates = coordinates
    }
    
    func saveToFirestore(picture: String,
                         title: String,
                         dateCreation: Date,
                         poster: String,
                         description: String,
                         hour: String,
                         category: String,
                         street: String,
                         city: String,
                         postalCode: String,
                         country: String,
                         latitude: Double,
                         longitude: Double
    ){
        
        let geoPoint =  GeoPoint(latitude: latitude, longitude: longitude)
        
        let adresse = Address(street: street, city: city, postalCode: postalCode, country: country, localisation: geoPoint)
        
        let event  = EventEntry(picture: picture, title: title, dateCreation: dateCreation, poster: poster, description: description, hour: hour, category: category, place: adresse )
        
        eventRepository.saveToFirestore(event) { success, error in
            if success {
                print("L'évènement a été sauvegardé avec succès.")
            }else{
                print("Erreur, \(error?.localizedDescription ?? "Inconnue")")
            }
        }
    }
    
    @MainActor
    func geocodeAddress(address: String) {
        let formattedAddress = address.replacingOccurrences(of: ",", with: ",")
            .capitalized
        
        guard !address.isEmpty else {
            self.errorMessage = "L'adresse est vide."
            self.coordinates = nil
            return
        }

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error { 
                self.errorMessage = error.localizedDescription
                self.coordinates = nil
            } else if let placemark = placemarks?.first, let location = placemark.location {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude

                // Vérification pour éviter les coordonnées nulles
                if latitude == 0.0 || longitude == 0.0 {
                    self.errorMessage = "Adresse géolocalisée avec des coordonnées invalides."
                    self.coordinates = nil
                } else {
                    self.coordinates = location.coordinate
                    self.errorMessage = nil
                }
            } else {
                self.errorMessage = "Adresse introuvable."
                self.coordinates = nil
            }
        }
    }

    
    func saveImageToTemporaryDirectory(image:UIImage, fileName:String) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        let tempDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do{
            try data.write(to: fileURL)
            return fileURL.path
            
        }catch{
            return nil
        }
    }
    func formatHourString(_ hour:Date) -> String{
        let date = Date.stringFromHour(hour)
        return date
    }
}
