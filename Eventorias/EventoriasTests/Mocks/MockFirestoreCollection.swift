//
//  MockFirestoreCollection.swift
//  EventoriasTests
//
//  Created by KEITA on 27/12/2024.
//
import XCTest
import Foundation
@testable import Eventorias
class MockFirestoreCollection : FirestoreCollectionProtocol {
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


