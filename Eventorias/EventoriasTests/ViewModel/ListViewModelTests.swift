//
//  ListViewModelTests.swift
//  EventoriasTests
//
//  Created by KEITA on 29/12/2024.
//
import XCTest
@testable import Eventorias

class ListViewModelTests: XCTestCase {
    var viewModel: ListViewModel!
    var mockEventListRepresentable: MockEventListRepresentable!
    
    override func setUp() {
        super.setUp()
        mockEventListRepresentable = MockEventListRepresentable()
        viewModel = ListViewModel(eventListRepresentable: mockEventListRepresentable)
    }
    
    override func tearDown() {
        viewModel = nil
        mockEventListRepresentable = nil
        super.tearDown()
    }
    
    // Test du formatage de la date
    func testFormatDateString() {
        let date = Date(timeIntervalSince1970: 0) // 1970-01-01
        let formattedDate = viewModel.formatDateString(date)
        XCTAssertNotNil(formattedDate) // Vérifiez votre format attendu
    }
    
    // Test de récupération des produits réussie
    func testGetAllProductsSuccess() async {
        mockEventListRepresentable.mockProducts = [
            EventEntry(picture: "https://example.com/event-picture.jpg",
                       title: "Annual Tech Conference",
                       dateCreation: Date(),
                       poster: "John Doe",
                       description: "An exciting tech conference showcasing the latest innovations in AI, blockchain, and IoT.",
                       hour: "10:00",
                       category: "Technology",
                       place: Address(street: "123 Innovation Drive", city: "Techville", postalCode: "94016", country: "USA" ,localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348))
                      ),  EventEntry(
                        picture: "https://example.com/event-picture.jpg",
                        title: "Annual",
                        dateCreation: Date(),
                        poster: "John Doe",
                        description: "An exciting tech conference showcasing the latest innovations in AI, blockchain, and IoT.",
                        hour: "10:00",
                        category: "Music",
                        place: Address(street: "123 Innovation Drive", city: "Techville", postalCode: "94016", country: "USA" ,localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348))
                      )
        ]
        
        try? await viewModel.getAllProducts()
        
        XCTAssertEqual(viewModel.eventEntry.count, 2)
        XCTAssertFalse(viewModel.isError)
    }
    
    // Test de récupération des produits échouée
    func testGetAllProductsFailure() async {
        mockEventListRepresentable.shouldThrowError = true
        
        try? await viewModel.getAllProducts()
        
        XCTAssertTrue(viewModel.isError)
        XCTAssertTrue(viewModel.eventEntry.isEmpty)
    }
    
    // Test de filtrage par catégorie
    func testFilterByCategory() async {
        mockEventListRepresentable.mockProducts = [
            EventEntry(picture: "https://example.com/event-picture.jpg",
                       title: "Annual Tech Conference",
                       dateCreation: Date(),
                       poster: "John Doe",
                       description: "An exciting tech conference showcasing the latest innovations in AI, blockchain, and IoT.",
                       hour: "10:00",
                       category: "Music",
                       place: Address(street: "123 Innovation Drive", city: "Techville", postalCode: "94016", country: "USA" ,localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348))
                      ),  EventEntry(
                        picture: "https://example.com/event-picture.jpg",
                        title: "Annual",
                        dateCreation: Date(),
                        poster: "John Doe",
                        description: "An exciting tech conference showcasing the latest innovations in AI, blockchain, and IoT.",
                        hour: "10:00",
                        category: "Sports",
                        place: Address(street: "123 Innovation Drive", city: "Techville", postalCode: "94016", country: "USA" ,localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348))
                      )
        ]
        
        try? await viewModel.filterSelected(option: .category)
        
        XCTAssertEqual(viewModel.eventEntry.first?.category, "Music")
        XCTAssertEqual(viewModel.eventEntry.last?.category, "Sports")
    }
    
    // Test de filtrage par date
    func testFilterByDate() async {
        let earlierDate = Date(timeIntervalSince1970: 0)
        let laterDate = Date()
        
        mockEventListRepresentable.mockProducts = [
            EventEntry(picture: "https://example.com/event-picture.jpg",
                       title: "Annual Tech Conference",
                       dateCreation: laterDate,
                       poster: "John Doe",
                       description: "An exciting tech conference showcasing the latest innovations in AI, blockchain, and IoT.",
                       hour: "10:00",
                       category: "Music",
                       place: Address(street: "123 Innovation Drive", city: "Techville", postalCode: "94016", country: "USA" ,localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348))
                      ),  EventEntry(
                        picture: "https://example.com/event-picture.jpg",
                        title: "Annual",
                        dateCreation:earlierDate,
                        poster: "John Doe",
                        description: "An exciting tech conference showcasing the latest innovations in AI, blockchain, and IoT.",
                        hour: "10:00",
                        category: "Sports",
                        place: Address(street: "123 Innovation Drive", city: "Techville", postalCode: "94016", country: "USA" ,localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348))
                      )
        ]
        
        try? await viewModel.filterSelected(option: .date)
        
        XCTAssertEqual(viewModel.eventEntry.first?.dateCreation, earlierDate)
        XCTAssertEqual(viewModel.eventEntry.last?.dateCreation, laterDate)
    }
    
    // Test de recherche par titre
    func testFilterTitle() {
        viewModel.eventEntry = [
            EventEntry(picture: "https://example.com/event-picture.jpg",
                       title: "Concert",
                       dateCreation: Date(),
                       poster: "John Doe",
                       description: "An exciting tech conference showcasing the latest innovations in AI, blockchain, and IoT.",
                       hour: "10:00",
                       category: "Music",
                       place: Address(street: "123 Innovation Drive", city: "Techville", postalCode: "94016", country: "USA" ,localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348))
                      ),  EventEntry(
                        picture: "https://example.com/event-picture.jpg",
                        title: "Annual",
                        dateCreation:Date(),
                        poster: "John Doe",
                        description: "An exciting tech conference showcasing the latest innovations in AI, blockchain, and IoT.",
                        hour: "10:00",
                        category: "Sports",
                        place: Address(street: "123 Innovation Drive", city: "Techville", postalCode: "94016", country: "USA" ,localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348))
                      )
        ]
        
        let filtered = viewModel.filterTitle("Concert")
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.title, "Concert")
    }
}
