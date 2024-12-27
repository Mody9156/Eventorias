//
//  MockFirestoreService.swift
//  EventoriasTests
//
//  Created by KEITA on 27/12/2024.
//

import XCTest
@testable import Eventorias

class MockFirestoreService: FirestoreService {
    var shouldSucceedFetch = true
    var shouldSucceedSave = true
    
    
    func saveUserData(userID: String, data: [String : Any], completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceedFetch {
            completion(.success(()))
        }else{
            completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Save failed"])))
            
        }
    }
    
    func fetchUserData(userID: String, completion: @escaping (Result<[String : Any], Error>) -> Void) {
        if shouldSucceedFetch {
            completion(.success([
                "firstName": "John",
                "lastName": "Doe",
                "email": "john.doe@example.com",
                "uid": userID,
                "picture": "mockPictureURL"
            ]))
        } else {
            completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Fetch failed"])))
        }
    }
    
    
}
