//
//  File.swift
//  Eventorias
//
//  Created by KEITA on 27/12/2024.
//


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreServiceEvents {
    private let firestore = Firestore.firestore()

    func collection(_ path: String) -> Query {
        return firestore.collection(path)
    }

    func getDocuments<T: Decodable>(from collection: Query) async throws -> [T] {
        let snapshot = try await collection.getDocuments()
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
