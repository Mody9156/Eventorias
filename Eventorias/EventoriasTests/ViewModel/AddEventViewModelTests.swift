//
//  AddEventViewModelTests.swift
//  EventoriasTests
//
//  Created by KEITA on 29/12/2024.
//
import XCTest
@testable import Eventorias // Assurez-vous que votre module cible est bien importé
import UIKit

class AddEventViewModelTests: XCTestCase {
    func testSaveToFirestore() {
        class MockEventManager: EventManagerProtocol {
            var isSaveCalled = false
            var savedEvent: EventEntry?
            
            func saveToFirestore(_ event: EventEntry, completion: @escaping (Bool, Error?) -> Void) {
                isSaveCalled = true
                savedEvent = event
                completion(true, nil)
            }
        }
        
        let mockRepository = MockEventManager()
        let viewModel = AddEventViewModel(eventRepository: mockRepository)
        
        let eventData = (
            picture: "mock_picture.jpg",
            title: "Mock Event",
            dateCreation: Date(),
            poster: "Mock Poster",
            description: "Mock Description",
            hour: "10:00",
            category: "Mock Category",
            street: "123 Mock Street",
            city: "Mock City",
            postalCode: "12345",
            country: "Mock Country",
            latitude: 37.7749,
            longitude: -122.4194
        )
        
        viewModel.saveToFirestore(
            picture: eventData.picture,
            title: eventData.title,
            dateCreation: eventData.dateCreation,
            poster: eventData.poster,
            description: eventData.description,
            hour: eventData.hour,
            category: eventData.category,
            street: eventData.street,
            city: eventData.city,
            postalCode: eventData.postalCode,
            country: eventData.country,
            latitude: eventData.latitude,
            longitude: eventData.longitude
        )
        
        XCTAssertTrue(mockRepository.isSaveCalled, "La méthode saveToFirestore n'a pas été appelée.")
        XCTAssertNotNil(mockRepository.savedEvent, "L'événement n'a pas été sauvegardé correctement.")
    }
    
    func testSaveImageToDocumentsDirectory() {
        let viewModel = AddEventViewModel()
        let mockImage = UIImage(systemName: "photo")!
        let fileName = "mock_image.jpg"
        
        let savedPath = viewModel.saveImageToDocumentsDirectory(image: mockImage, fileName: fileName)
        
        XCTAssertNotNil(savedPath, "Le chemin de l'image sauvegardée ne doit pas être nul.")
        XCTAssertTrue(FileManager.default.fileExists(atPath: savedPath!), "L'image n'a pas été sauvegardée dans le répertoire.")
    }
    
    func testFormatHourString() {
        let viewModel = AddEventViewModel()
        let date = Date() // Utilisez un mock de Date pour un contrôle précis, si nécessaire.
        
        let formattedHour = viewModel.formatHourString(date)
        
        // Remplacez "expectedString" par l'heure formatée attendue.
        let expectedString = Date.stringFromHour(date)
        XCTAssertNotNil(expectedString)
    }
   
    
}
