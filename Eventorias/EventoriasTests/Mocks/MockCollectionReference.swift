////
////  MockCollectionReference.swift
////  EventoriasTests
////
////  Created by KEITA on 28/12/2024.
////
//import XCTest
//import FirebaseFirestore
//@testable import Eventorias
//
//class MockCollectionReference :CollectionReferenceProtocol{
//    var addDocumentCalled = false
//    var documentData: [String: Any]?
//    var errorToReturn: Error?
//
//    func addDocumentWithData(data: [String: Any], completion: @escaping (Error?) -> Void) {
//        addDocumentCalled = true
//        documentData = data
//
//        // Simuler l'erreur si spécifiée
//        if let error = errorToReturn {
//            completion(error)
//        } else {
//            completion(nil) // Simuler un succès
//        }
//    }
//}
