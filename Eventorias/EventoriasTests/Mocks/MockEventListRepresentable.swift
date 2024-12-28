//
//  MockEventListRepresentable.swift
//  EventoriasTests
//
//  Created by KEITA on 29/12/2024.
//
import Foundation
@testable import Eventorias

class MockEventListRepresentable: EventListRepresentable {
    var mockProducts: [EventEntry] = []
    var shouldThrowError = false

    func getAllProducts() async throws -> [EventEntry] {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: -1, userInfo: nil)
        }
        return mockProducts
    }

    func getAllProductsSortedByCategory() async throws -> [EventEntry] {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: -1, userInfo: nil)
        }
        return mockProducts.sorted { $0.category < $1.category }
    }

    func getAllProductsSortedByDate() async throws -> [EventEntry] {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: -1, userInfo: nil)
        }
        return mockProducts.sorted { $0.dateCreation < $1.dateCreation }
    }
}
