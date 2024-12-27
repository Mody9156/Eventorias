//
//  FirestoreCollectionProtocolToList.swift
//  Eventorias
//
//  Created by KEITA on 27/12/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirestoreQueryProtocol {
    func getDocuments() async throws -> [DocumentSnapshot]
    func order(by field: String, descending: Bool) -> FirestoreQueryProtocol
}

protocol FirestoreCollectionProtocols: FirestoreQueryProtocol {}

extension CollectionReference: FirestoreCollectionProtocol {
    func getDocumentsToList() async throws -> [DocumentSnapshot] {
        let snapshot = try await self.getDocuments()
        return snapshot.documents
    }

    func order(by field: String, descending: Bool) -> FirestoreQueryProtocol {
        return self.order(by: field, descending: descending)
    }
}
