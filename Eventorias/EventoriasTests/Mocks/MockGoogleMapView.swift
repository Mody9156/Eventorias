//
//  MockGoogleMapView.swift
//  EventoriasTests
//
//  Created by KEITA on 28/12/2024.
//

import XCTest
@testable import Eventorias
class MockGoogleMapView: GoogleMapView {
    var mockData: Data?
    var mockResponse: HTTPURLResponse?
    var mockError: Error?
    
    override func showMapsWithURLRequest(_ latitude: Double, _ longitude: Double, _ key: String) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockData ?? Data()
    }
}
class MockListViewModel {
    var eventEntry: [EventEntry]
    
    init(eventEntry: [EventEntry]) {
        self.eventEntry = eventEntry
    }
}
