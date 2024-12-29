//
//  RegistrationViewModel.swift
//  Eventorias
//
//  Created by KEITA on 17/12/2024.
//

import Foundation
import PhotosUI
import CoreLocation
import FirebaseStorage
import FirebaseAppCheckInterop
import FirebaseAuthInterop
import FirebaseCoreExtension
import FirebaseStorageInternal

class AddEventViewModel : ObservableObject {
    let eventRepository: EventManagerProtocol
    
    init(eventRepository: EventManagerProtocol = EventRepository()) {
        self.eventRepository = eventRepository
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
        
    func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("Échec de la conversion de l'image en données JPEG.")
            return nil
        }
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            print("Image sauvegardée à : \(fileURL.path)")
            return fileURL.path
        } catch {
            print("Erreur lors de la sauvegarde de l'image : \(error)")
            return nil
        }
    }
    
    
    func formatHourString(_ hour:Date) -> String{
        let date = Date.stringFromHour(hour)
        return date
    }
    

    
}
