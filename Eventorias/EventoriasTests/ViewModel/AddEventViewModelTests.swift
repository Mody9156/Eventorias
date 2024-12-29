//
//  AddEventViewModelTests.swift
//  EventoriasTests
//
//  Created by KEITA on 29/12/2024.
//
//
//  AddEventViewModelTests.swift
//  EventoriasTests
//
//  Created by KEITA on 29/12/2024.
//

import XCTest
@testable import Eventorias

class AddEventViewModelTests: XCTestCase {

    func testSaveToFirestore() {
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
        
        XCTAssertNotNil(mockRepository.savedEvent, "L'événement n'a pas été sauvegardé correctement.")
        XCTAssertEqual(mockRepository.savedEvent?.title, eventData.title, "Le titre de l'événement sauvegardé est incorrect.")
        XCTAssertEqual(mockRepository.savedEvent?.picture, eventData.picture, "L'image de l'événement sauvegardé est incorrecte.")
        XCTAssertEqual(mockRepository.savedEvent?.poster, eventData.poster, "Le poster de l'événement sauvegardé est incorrect.")
        XCTAssertEqual(mockRepository.savedEvent?.place.city, eventData.city, "La ville de l'événement sauvegardé est incorrecte.")
        XCTAssertEqual(mockRepository.savedEvent?.place.country, eventData.country, "Le pays de l'événement sauvegardé est incorrect.")
        XCTAssertEqual(mockRepository.savedEvent?.place.localisation.latitude, eventData.latitude, "La latitude de l'événement sauvegardé est incorrecte.")
        XCTAssertEqual(mockRepository.savedEvent?.place.localisation.longitude, eventData.longitude, "La longitude de l'événement sauvegardé est incorrecte.")
    }

    func testUploadImageToFirebaseStorage() async {
        let mockRepository = MockEventManager()
        let viewModel = AddEventViewModel(eventRepository: mockRepository)
        
        let imageData = Data("mock_image_data".utf8)
        
        await viewModel.uploadImageToFirebaseStorage(imageData: imageData)
        
        // Vérifications
        XCTAssertEqual(viewModel.imageUrl, "https://mock.url/image.jpg", "L'URL de l'image téléchargée est incorrecte.")
        XCTAssertTrue(mockRepository.isImageUrlSaved, "L'URL de l'image n'a pas été sauvegardée.")
        XCTAssertEqual(mockRepository.savedImageUrl, "https://mock.url/image.jpg", "L'URL sauvegardée dans Firestore est incorrecte.")
    }
    
    func testSaveImageUrlToFirestore() {
        let mockRepository = MockEventManager()
        let viewModel = AddEventViewModel(eventRepository: mockRepository)
        
        let imageUrl = "https://mock.url/image.jpg"
        viewModel.saveImageUrlToFirestore(url: imageUrl)
        
        // Vérifications
        XCTAssertTrue(mockRepository.isImageUrlSaved, "L'URL de l'image n'a pas été sauvegardée.")
        XCTAssertEqual(mockRepository.savedImageUrl, imageUrl, "L'URL sauvegardée dans Firestore est incorrecte.")
        XCTAssertEqual(mockRepository.savedEventID, "ID de l'événement à mettre ici", "L'ID de l'événement sauvegardé est incorrect.")
    }
    
    func testFormatHourString() {
        let viewModel = AddEventViewModel()
        let date = Date()
        
        let formattedHour = viewModel.formatHourString(date)
        let expectedHour = Date.stringFromHour(date)
        
        XCTAssertEqual(formattedHour, expectedHour, "Le formatage de l'heure est incorrect.")
    }
}
