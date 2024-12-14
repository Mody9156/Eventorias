//
//  EventoriasRepository.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public class EventoriasRepository : EventListRepresentable {
    var db = Firestore.firestore().collection("eventorias")
    
    // Méthode pour récupérer tous les produits (événements)
    func getAllProducts() async throws -> [EventEntry] {
        try await db.getDocuments(as: EventEntry.self)
    }
    
    // Méthode pour récupérer tous les produits triés par date
    func getAllProductsSortedByDate() async throws -> [EventEntry] {
        try await db.order(by: "dateCreationString", descending: true).getDocuments(as: EventEntry.self)
    }
    
    // Méthode pour récupérer tous les produits triés par catégorie
    func getAllProductsSortedByCategory() async throws -> [EventEntry] {
        try await db.order(by: "category", descending: true).getDocuments(as: EventEntry.self)
    }
}

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        let snapshot = try await self.getDocuments()
        
//        for document in snapshot.documents {
//            print("Elements du tableau :  \(document.data())")
//        }
        
//        print("Il y a \(snapshot.count)")
        
        // Conversion des données en objets de type T
        return try snapshot.documents.map { document in
            do{
                let data = try document.data(as: T.self)
                // Print pour afficher les données décodées
//                print("Document décodé avec succès : \(data)")
                return data
            } catch {
                // Print pour l'erreur si la conversion échoue
//                print("Erreur de décodage pour le document ID: \(document.documentID), erreur: \(error)")
                throw error
            }
        }
    }
}
