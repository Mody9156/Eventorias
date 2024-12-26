//
//  MockFirestoreCollection.swift
//  EventoriasTests
//
//  Created by KEITA on 26/12/2024.
//
import XCTest
@testable import VotreModule // Remplacez avec le nom de votre module

class MockFirestoreCollection {
    var shouldSucceed: Bool = true
    var capturedData: [String: Any]?
    
    func addDocument(data: [String: Any], completion: @escaping (Error?) -> Void) {
        capturedData = data
        if shouldSucceed {
            completion(nil) // Simule le succès
        } else {
            completion(MockFirestoreError.addDocumentFailed) // Simule une erreur
        }
    }
}

enum MockFirestoreError: Error {
    case addDocumentFailed
}

protocol MockFirestoreProtocol {
    func addDocument(data: [String: Any], completion: @escaping (Error?) -> Void)
}

extension MockFirestoreCollection: MockFirestoreProtocol {}
