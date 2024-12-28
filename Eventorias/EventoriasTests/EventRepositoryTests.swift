////
////  EventoriasTests.swift
////  EventoriasTests
////
////  Created by KEITA on 28/12/2024.
////
//
//import XCTest
//import FirebaseFirestore
//@testable import Eventorias
//
//class EventRepositoryTests: XCTestCase {
//
//    var eventRepository: EventRepository!
//    var mockCollection: MockCollectionReference!
//
//    override func setUp() {
//           super.setUp()
//
//           // Initialiser le mock
//           mockCollection = MockCollectionReference()
//           eventRepository = EventRepository()
//       }
//
//    override func tearDown() {
//        eventRepository = nil
//        mockCollection = nil
//        super.tearDown()
//    }
//
//    func testSaveToFirestore_Success() {
//        // Préparer un événement
//        let event = EventEntry(
//                        picture: "https://example.com/event-picture.jpg",
//                        title: "Annual Tech Conference",
//                        dateCreation: Date(),
//                        poster: "John Doe",
//                        description: "An exciting tech conference showcasing the latest innovations in AI, blockchain, and IoT.",
//                        hour: "10:00",
//                        category: "Technology",
//                        place: Address(street: "123 Innovation Drive", city: "Techville", postalCode: "94016", country: "USA" ,localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348))
//                    )
//
//
//        // Appeler la méthode saveToFirestore
//        eventRepository.saveToFirestore(event) { success, error in
//            XCTAssertTrue(success)
//            XCTAssertNil(error)
//            XCTAssertTrue(self.mockCollection.addDocumentCalled)
//            XCTAssertNotNil(self.mockCollection.documentData)
//        }
//    }
//
//    func testSaveToFirestore_EncodingFailure() {
//        // Préparer un événement avec une mauvaise structure (pour tester l'échec d'encodage)
//
//        let invalidEvent = EventEntry(
//            picture: "",
//            title: "",
//            dateCreation: Date(),
//            poster: "",
//            description: "",
//            hour: "",
//            category: "",
//            place: Address(street: "123 Innovation Drive", city: "Techville", postalCode: "94016", country: "USA" ,localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348))
//        )
//
//        // Appeler la méthode saveToFirestore
//        eventRepository.saveToFirestore(invalidEvent) { success, error in
//            XCTAssertFalse(success)
//            XCTAssertNotNil(error)
//        }
//    }
//
//    func testSaveToFirestore_FirestoreError() {
//        // Préparer un événement
//        let event = EventEntry(
//            picture: "https://example.com/event-picture.jpg",
//            title: "Annual Tech Conference",
//            dateCreation: Date(),
//            poster: "John Doe",
//            description: "An exciting tech conference showcasing the latest innovations in AI, blockchain, and IoT.",
//            hour: "10:00",
//            category: "Technology",
//            place: Address(street: "123 Innovation Drive", city: "Techville", postalCode: "94016", country: "USA" ,localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348))
//        )
//
//        // Simuler une erreur Firestore
//        mockCollection.errorToReturn = NSError(domain: "Firestore", code: -1, userInfo: nil)
//
//        // Appeler la méthode saveToFirestore
//        eventRepository.saveToFirestore(event) { success, error in
//            XCTAssertFalse(success)
//            XCTAssertNotNil(error)
//        }
//    }
//}
