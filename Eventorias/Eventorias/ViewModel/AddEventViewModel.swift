import Foundation
import PhotosUI
import CoreLocation
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AddEventViewModel: ObservableObject {
    let eventRepository: EventManagerProtocol
    
    @Published var imageUrl: String?
    
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
    
    func formatHourString(_ hour: Date) -> String {
        return Date.stringFromHour(hour)
    }
    
    func uploadImageToFirebaseStorage(imageData: Data) async {
        await eventRepository.uploadImageToFirebaseStorage(imageData: imageData) { [weak self] imageUrl, error in
            if let error = error {
                print("Erreur lors du téléchargement de l'image : \(error.localizedDescription)")
                return
            }
            
            if let imageUrl = imageUrl {
                print("Image téléchargée avec succès. URL : \(imageUrl)")
                self?.imageUrl = imageUrl
                
                self?.saveImageUrlToFirestore(url: imageUrl)
            }
        }
    }
    
    func saveImageUrlToFirestore(url: String) {
        
        let eventID = "ID de l'événement à mettre ici"
        
        eventRepository.saveImageUrlToFirestore(url: url, eventID: eventID) { success, error in
            if success {
                print("URL de l'image sauvegardée avec succès dans Firestore.")
            } else if let error = error {
                print("Erreur lors de la sauvegarde de l'URL dans Firestore : \(error.localizedDescription)")
            }
        }
    }
}
