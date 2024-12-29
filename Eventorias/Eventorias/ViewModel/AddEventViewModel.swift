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

class AddEventViewModel: ObservableObject {
    let eventRepository: EventManagerProtocol
    
    // Pour stocker l'URL de l'image téléchargée
    @Published var imageUrl: String?
    
    init(eventRepository: EventManagerProtocol = EventRepository()) {
        self.eventRepository = eventRepository
    }
    
    // Sauvegarder un événement dans Firestore
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
                         longitude: Double) {
        let geoPoint = GeoPoint(latitude: latitude, longitude: longitude)
        let adresse = Address(street: street, city: city, postalCode: postalCode, country: country, localisation: geoPoint)
        let event = EventEntry(picture: picture, title: title, dateCreation: dateCreation, poster: poster, description: description, hour: hour, category: category, place: adresse)
        
        eventRepository.saveToFirestore(event) { success, error in
            if success {
                print("L'évènement a été sauvegardé avec succès.")
            } else {
                print("Erreur, \(error?.localizedDescription ?? "Inconnue")")
            }
        }
    }
    
    // Sauvegarder une image dans le répertoire Documents de l'appareil
    func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            print("Erreur : Impossible de convertir l'image en données JPEG.")
            return nil
        }

        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Erreur : Impossible de trouver le répertoire Documents.")
            return nil
        }

        let fileURL = documentsURL.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            print("Image sauvegardée à : \(fileURL.path)")
            
            // Encoder le chemin du fichier pour le convertir en URL valide
            let encodedURL = fileURL.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? fileURL.absoluteString
            print("URL encodée : \(encodedURL)")

            return fileURL.path
        } catch {
            print("Erreur lors de la sauvegarde de l'image : \(error)")
            return nil
        }
    }

    // Formatter une heure (Date) en chaîne lisible
    func formatHourString(_ hour: Date) -> String {
        return Date.stringFromHour(hour)
    }
    
    // Téléchargement d'une image dans Firebase Storage
    func uploadImageToFirebaseStorage(imageData: Data) async {
        await eventRepository.uploadImageToFirebaseStorage(imageData: imageData) { [weak self] imageUrl, error in
            if let error = error {
                print("Erreur lors du téléchargement de l'image : \(error.localizedDescription)")
                return
            }
            
            if let imageUrl = imageUrl {
                print("Image téléchargée avec succès. URL : \(imageUrl)")
                self?.imageUrl = imageUrl // Mise à jour de l'URL dans le ViewModel
                self?.saveImageUrlToFirestore(url: imageUrl)
            }
        }
    }
    
    // Sauvegarde de l'URL de l'image dans Firestore
    func saveImageUrlToFirestore(url: String) {
        eventRepository.saveImageUrlToFirestore(url: url) { success, error in
            if success {
                print("URL de l'image sauvegardée avec succès dans Firestore.")
            } else if let error = error {
                print("Erreur lors de la sauvegarde de l'URL dans Firestore : \(error.localizedDescription)")
            }
        }
    }
}
