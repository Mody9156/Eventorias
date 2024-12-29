import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit
import FirebaseStorage

public class EventRepository: ObservableObject, EventManagerProtocol {
    var db = Firestore.firestore().collection("eventorias")
    
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
    
    func uploadImageToFirebaseStorage(imageData: Data, completion: @escaping (String?, Error?) -> Void) async {
        guard let image = UIImage(data: imageData) else {
            print("Erreur : Impossible de créer l'image à partir des données.")
            return
        }
        
        let fileName = UUID().uuidString + ".jpg"
        
        let storageRef = Storage.storage().reference(forURL: "gs://eventorias-4bacf.firebasestorage.app").child("eventImages/\(fileName)")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        do {
            let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)

            let downloadURL = try await storageRef.downloadURL()
            completion(downloadURL.absoluteString, nil)
        } catch let error as NSError  {
            print("Erreur lors du téléchargement de l'image : \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
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
