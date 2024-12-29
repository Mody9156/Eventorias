//
//  MockEventManager.swift
//  EventoriasTests
//
//  Created by KEITA on 29/12/2024.
//

import XCTest
@testable import Eventorias

class MockEventManager: EventManagerProtocol {
    var isSaveToFirestoreCalled = false
    var savedEvent: EventEntry?

    var isImageUrlSaved = false
    var savedImageUrl: String?
    var savedEventID: String?
    
    func saveImageUrlToFirestore(url: String, eventID: String, completion: @escaping (Bool, Error?) -> Void) {
        isImageUrlSaved = true
        savedImageUrl = url
        savedEventID = eventID
        completion(true, nil) // Simuler un succès de sauvegarde
    }
    
    func uploadImageToFirebaseStorage(imageData: Data, completion: @escaping (String?, Error?) -> Void) async {
        completion("https://mock.url/image.jpg", nil)
    }
    
    func saveToFirestore(_ event: EventEntry, completion: @escaping (Bool, Error?) -> Void) {
        isSaveToFirestoreCalled = true
        savedEvent = event
        completion(true, nil) // Simuler un succès de sauvegarde
    }
}
