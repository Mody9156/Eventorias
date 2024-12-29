import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit
import FirebaseStorage

public class EventRepository: ObservableObject, EventManagerProtocol {
    var db = Firestore.firestore().collection("eventorias")
    
    // Sauvegarder un événement dans Firestore
    func saveToFirestore(_ event: EventEntry, completion: @escaping (Bool, Error?) -> Void) {
        do {
            let encodedEvent = try Firestore.Encoder().encode(event)
            db.addDocument(data: encodedEvent) { error in
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        } catch let encodingError {
            completion(false, encodingError)
        }
    }
    
    // Télécharger une image vers Firebase Storage
    func uploadImageToFirebaseStorage(imageData: Data, completion: @escaping (String?, Error?) -> Void) async {
        // Créer une image à partir des données
        guard let image = UIImage(data: imageData) else {
            print("Erreur : Impossible de créer l'image à partir des données.")
            return
        }
        
        // Générer un nom de fichier unique pour chaque image
        let fileName = UUID().uuidString + ".jpg"
        
        // Référence Firebase Storage avec un chemin spécifique
        let storageRef = Storage.storage().reference(forURL: "gs://eventorias-4bacf.firebasestorage.app").child("eventImages/\(fileName)")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        do {
            // Télécharger les données vers Firebase Storage
            let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)

            // Obtenir l'URL de téléchargement de l'image
            let downloadURL = try await storageRef.downloadURL()
            completion(downloadURL.absoluteString, nil)
        } catch let error as NSError  {
            // Capture d'erreur détaillée et retour du message
            print("Erreur lors du téléchargement de l'image : \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
    // Sauvegarder l'URL d'une image dans Firestore
    func saveImageUrlToFirestore(url: String, eventID: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        let eventRef = db.collection("eventorias").document(eventID)
        
        eventRef.updateData([
            "imageUrl": url,
            "timestamp": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
}
