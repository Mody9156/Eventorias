//
//  EventRepositoryTestss.swift
//  EventoriasTests
//
//  Created by KEITA on 27/12/2024.
//

import XCTest

final class EventRepositoryTestss: XCTestCase {
    //
    //    func testSaveToFirestoreSuccess()  {
    //        let mockDb = MockFirestoreCollection()
    //        mockDb.shouldSucceed = true
    //        let repository = EventRepository(db: mockDb)
    //        let testsEvent = EventEntry(
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
    //        let expectation = self.expectation(description: "Save should succeed")
    //
    //        repository.saveToFirestore(testsEvent) { succes, error in
    //            XCTAssertTrue(succes)
    //            XCTAssert(((mockDb.capturedData?["poster"] as? String) != nil), "John Doe")
    //            XCTAssert(((mockDb.capturedData?["category"] as? String) != nil), "Technology")
    //            expectation.fulfill()
    //        }
    //        waitForExpectations(timeout:10)
    //
    //    }
    //
    //
}
