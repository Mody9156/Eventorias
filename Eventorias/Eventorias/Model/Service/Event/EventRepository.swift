//
//  EventRepository.swift
//  Eventorias
//
//  Created by KEITA on 17/12/2024.
//

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
        guard UIImage(data: imageData) != nil else {
            completion(nil, NSError(domain: "InvalidImage", code: 400, userInfo: [NSLocalizedDescriptionKey: "Données d'image invalides"]))
            return
        }
        
        let fileName = UUID().uuidString + ".jpg"
        let storageRef = Storage.storage().reference().child("images/\(fileName)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        do {
            // Télécharger les données vers Firebase Storage
            let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
            
            // Obtenir l'URL de téléchargement de l'image
            let downloadURL = try await storageRef.downloadURL()
            completion(downloadURL.absoluteString, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    // Sauvegarder l'URL d'une image dans Firestore
    func saveImageUrlToFirestore(url: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        let imageRef = db.collection("images").document()
        
        imageRef.setData([
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
