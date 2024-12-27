//
//  MockFirestoreList.swift
//  EventoriasTests
//
//  Created by KEITA on 27/12/2024.
//

import XCTest
@testable import Eventorias
import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

// Simuler un document de Firestore
class MockQueryDocumentSnapshot: QueryDocumentSnapshot {
    private var mockData: [String: Any]
    var documentID: String
    
    init(mockData: [String: Any], documentID: String = UUID().uuidString) {
        self.mockData = mockData
        self.documentID = documentID
    }
    
    override func data() -> [String: Any] {
        return mockData
    }
}

// Simuler un Snapshot de requête Firestore
class MockQuerySnapshot: QuerySnapshot {
    private var mockDocuments: [MockQueryDocumentSnapshot]
    
    init(documents: [MockQueryDocumentSnapshot]) {
        self.mockDocuments = documents
    }
    
    override var documents: [QueryDocumentSnapshot] {
        return mockDocuments
    }
    
    // Simuler la méthode 'order' sur les données (en retournant un nouveau mock trié)
     func order(by fieldPath: String, descending: Bool) -> Query {
        let sortedDocuments = mockDocuments.sorted { doc1, doc2 in
            if let first = doc1.data()[fieldPath] as? String, let second = doc2.data()[fieldPath] as? String {
                return descending ? first > second : first < second
            }
            return false
        }
        return MockQuerySnapshot(documents: sortedDocuments)
    }
    
    // Simuler un appel à getDocuments avec décodeur
    func getDocuments<T>(as type: T.Type) throws -> [T] where T: Decodable {
        return try mockDocuments.map { document in
            return try document.data() as! T
        }
    }
}
