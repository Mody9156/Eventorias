//
//  EventoriasTests.swift
//  EventoriasTests
//
//  Created by KEITA on 28/12/2024.
//

import XCTest
@testable import Eventorias

class EventRepositoryTests: XCTestCase {
    
    var eventRepository: EventRepository!
    var mockCollection: MockCollectionReference!
    
    override func setUp() {
        super.setUp()
        
        // Initialiser le mock
        mockCollection = MockCollectionReference()
        eventRepository = EventRepository(db: mockCollection)
    }
    
    override func tearDown() {
        eventRepository = nil
        mockCollection = nil
        super.tearDown()
    }
    
    func testSaveToFirestore_Success() {
        // Préparer un événement
        let event = EventEntry(id: "1", title: "Event Test", description: "Description", date: Date())
        
        // Appeler la méthode saveToFirestore
        eventRepository.saveToFirestore(event) { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            XCTAssertTrue(self.mockCollection.addDocumentCalled)
            XCTAssertNotNil(self.mockCollection.documentData)
        }
    }
    
    func testSaveToFirestore_EncodingFailure() {
        // Préparer un événement avec une mauvaise structure (pour tester l'échec d'encodage)
        struct InvalidEvent: Codable {
            let invalidField: Any
        }
        let invalidEvent = InvalidEvent(invalidField: NSObject())
        
        // Appeler la méthode saveToFirestore
        eventRepository.saveToFirestore(invalidEvent) { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
        }
    }
    
    func testSaveToFirestore_FirestoreError() {
        // Préparer un événement
        let event = EventEntry(id: "2", title: "Event Test", description: "Description", date: Date())
        
        // Simuler une erreur Firestore
        mockCollection.errorToReturn = NSError(domain: "Firestore", code: -1, userInfo: nil)
        
        // Appeler la méthode saveToFirestore
        eventRepository.saveToFirestore(event) { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
        }
    }
}
