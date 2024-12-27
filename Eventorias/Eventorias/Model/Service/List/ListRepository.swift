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
    private let firestoreService: FirestoreServiceEvents
    private let collectionPath: String
    
    init(firestoreService: FirestoreServiceEvents, collectionPath: String = "eventorias") {
        self.firestoreService = firestoreService
        self.collectionPath = collectionPath
    }
    
    // Méthode pour récupérer tous les produits (événements)
    func getAllProducts() async throws -> [EventEntry] {
        let query = firestoreService.collection(collectionPath)
        return try await firestoreService.getDocuments(from: query) // Utilise la méthode générique
    }
    
    // Méthode pour récupérer tous les produits triés par date
    func getAllProductsSortedByDate() async throws -> [EventEntry] {
        let query = firestoreService.collection(collectionPath)
            .order(by: "dateCreationString", descending: true)
        return try await firestoreService.getDocuments(from: query) // Utilise la méthode générique
    }
    
    // Méthode pour récupérer tous les produits triés par catégorie
    func getAllProductsSortedByCategory() async throws -> [EventEntry] {
        let query = firestoreService.collection(collectionPath)
            .order(by: "category", descending: true)
        return try await firestoreService.getDocuments(from: query) // Utilise la méthode générique
    }
}

