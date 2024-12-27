//
//  EventoriasRepository.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public class ListRepository : EventListRepresentable {
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
        let snapshot = try await self.getDocuments() // Appel Firestore pour récupérer le snapshot
        return try snapshot.documents.map { document in
            // Décode chaque document en un objet de type T (EventEntry, par exemple)
            do {
                let data = try document.data(as: T.self)
                return data
            } catch {
                throw error
            }
        }
    }
}
