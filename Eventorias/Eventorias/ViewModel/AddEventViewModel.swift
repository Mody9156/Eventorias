import Foundation
import PhotosUI
import CoreLocation
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

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
    
    

    // Formatter une heure (Date) en chaîne lisible
    func formatHourString(_ hour: Date) -> String {
        return Date.stringFromHour(hour)
    }
    
    // Téléchargement d'une image dans Firebase Storage
    func uploadImageToFirebaseStorage(imageData: Data) async {
        // Téléchargement de l'image
        await eventRepository.uploadImageToFirebaseStorage(imageData: imageData) { [weak self] imageUrl, error in
            if let error = error {
                // Gestion des erreurs de téléchargement
                print("Erreur lors du téléchargement de l'image : \(error.localizedDescription)")
                return
            }
            
            if let imageUrl = imageUrl {
                // Mise à jour de l'URL dans le ViewModel
                print("Image téléchargée avec succès. URL : \(imageUrl)")
                self?.imageUrl = imageUrl
                
                // Sauvegarder l'URL dans Firestore après téléchargement
                self?.saveImageUrlToFirestore(url: imageUrl)
            }
        }
    }
    
    // Sauvegarde de l'URL de l'image dans Firestore
    func saveImageUrlToFirestore(url: String) {
        // Assurez-vous d'avoir l'ID de l'événement avant de sauvegarder l'URL
        // Par exemple, si l'événement est déjà sauvegardé, récupérez l'ID du document
        let eventID = "ID de l'événement à mettre ici" // Vous devez obtenir l'ID réel du document Firestore de l'événement
        
        eventRepository.saveImageUrlToFirestore(url: url, eventID: eventID) { success, error in
            if success {
                print("URL de l'image sauvegardée avec succès dans Firestore.")
            } else if let error = error {
                // Gestion des erreurs lors de la sauvegarde de l'URL
                print("Erreur lors de la sauvegarde de l'URL dans Firestore : \(error.localizedDescription)")
            }
        }
    }
}
