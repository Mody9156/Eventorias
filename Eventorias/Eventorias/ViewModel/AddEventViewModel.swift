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
    func sanitizeFileName(_ fileName: String) -> String {
        return fileName
            .replacingOccurrences(of: " ", with: "_") // Remplace les espaces par des underscores
            .replacingOccurrences(of: "[^a-zA-Z0-9_]", with: "", options: .regularExpression) // Supprime tous les caractères non-alphanumériques sauf "_"
    }

    func uploadImageToFirebase(image: UIImage, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Utilisation de la fonction sanitizeFileName pour nettoyer le nom du fichier
        let sanitizedFileName = sanitizeFileName(fileName)

        // Conversion de l'image en données JPEG
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Erreur lors de la conversion de l'image."])))
            return
        }
        
        // Référence Firebase Storage avec le nom de fichier "sanitisé"
        let storageRef = Storage.storage().reference().child("eventorias/\(sanitizedFileName)")
        
        // Téléchargement des données sur Firebase
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                // Une fois l'image téléchargée, récupérer l'URL de téléchargement
                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url.absoluteString))
                    }
                }
            }
        }
    }

}
