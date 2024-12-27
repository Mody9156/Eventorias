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
class MockFirestoreList {
    var documents : [QueryDocumentSnapshot]
    
    init(documents : [QueryDocumentSnapshot]) {
        self.documents = documents
    }
    
    func getDocument() async throws -> QuerySnapshot {
        return MockQuerySnapshot(documents: documents)
    }
    
}

class MockQuerySnapshot: QuerySnapshot {
         var mockDocuments: [QueryDocumentSnapshot]
        
        init(documents: [QueryDocumentSnapshot]) {
            self.mockDocuments = documents
        }
        
        override var documents: [QueryDocumentSnapshot] {
            return mockDocuments
        }
    }
    
    class MockQueryDocumentSnapshot: QueryDocumentSnapshot {
        private let mockData: [String: Any]
        
        init(data: [String: Any]) {
            self.mockData = data
        }
        
        override func data() -> [String: Any] {
            return mockData
        }
    }

