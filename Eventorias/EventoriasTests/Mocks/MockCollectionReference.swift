//
//  MockCollectionReference.swift
//  EventoriasTests
//
//  Created by KEITA on 28/12/2024.
//
import FirebaseFirestore
import XCTest

// Mock de CollectionReference
class MockCollectionReference: CollectionReference {
    var addDocumentCalled = false
    var documentData: [String: Any]?
    var errorToReturn: Error?
    
     func addDocument(data: [String: Any], completion: @escaping (Error?) -> Void) {
        addDocumentCalled = true
        documentData = data
        
        // Simuler l'erreur si spécifiée
        if let error = errorToReturn {
            completion(error)
        } else {
            completion(nil) // Simuler un succès
        }
    }
}
