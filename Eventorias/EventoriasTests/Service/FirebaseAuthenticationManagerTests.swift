//
//  FirebaseAuthenticationManagerTests.swift
//  EventoriasTests
//
//  Created by KEITA on 27/12/2024.
//

import XCTest
@testable import Eventorias
final class FirebaseAuthenticationManagerTests: XCTestCase {
    
    var firebaseAuthManager: FirebaseAuthenticationManager!
    var mockAuthService: MockAuthService!
    var mockFirestoreService: MockFirestoreService!
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        mockFirestoreService = MockFirestoreService()
        firebaseAuthManager = FirebaseAuthenticationManager(authService: mockAuthService, firestoreService: mockFirestoreService)
    }
    
    override func tearDown() {
        super.tearDown()
        mockAuthService = nil
        mockFirestoreService = nil
        firebaseAuthManager  = nil
    }
    
    func testUserInitialization(){
        
        let userDict: [String: Any] = [
            "firstName": "John",
            "lastName": "Doe",
            "email": "john.doe@example.com",
            "uid": "12345",
            "picture": "http://example.com/picture.jpg"
        ]
        
        //initialisation de l'object User
        guard let user = User(from: userDict) else {
            XCTFail("User initialization failed")
            return
        }
        
        XCTAssertEqual(user.firstName, "John")
        XCTAssertEqual(user.lastName, "Doe")
        XCTAssertEqual(user.email, "john.doe@example.com")
        XCTAssertEqual(user.uid, "12345")
        XCTAssertEqual(user.picture, "http://example.com/picture.jpg")
    }
    
    func testUserToDictionary() {
        let userDict: [String: Any] = [
            "firstName": "John",
            "lastName": "Doe",
            "email": "john.doe@example.com",
            "uid": "12345",
            "picture": "http://example.com/picture.jpg"
        ]
        
        //initialisation de l'object User
        guard let user = User(from: userDict) else {
            XCTFail("User initialization failed")
            return
        }
        
        
        
        // Conversion de l'objet User en dictionnaire
        let userDictionary = user.toDictionary()
        
        // Vérification que le dictionnaire est correct
        XCTAssertEqual(userDict["firstName"] as? String, "John")
        XCTAssertEqual(userDict["lastName"] as? String, "Doe")
        XCTAssertEqual(userDict["email"] as? String, "john.doe@example.com")
        XCTAssertEqual(userDict["uid"] as? String, "12345")
        XCTAssertEqual(userDict["picture"] as? String, "http://example.com/picture.jpg")
    }
    
    func testSignInSuccess(){
        //simuler un succès
        mockAuthService.shouldSucceedSign = true
        mockFirestoreService.shouldSucceedSave = true
        
        let expectation = self.expectation(description: "signIn should succeed")
        
        firebaseAuthManager.signIn(email: "john.doe@example.com", password: "password123") { result in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.firstName, "John")
                XCTAssertEqual(user.lastName, "Doe")
                XCTAssertEqual(user.email, "john.doe@example.com")
                XCTAssertEqual(user.picture, "mockPictureURL")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected signIn to succeed, but it failed")
            }
        }
        waitForExpectations(timeout: 1.0, handler: nil)
        
    }
    
    func testSingInFailure(){
        //simuler une erreur de connexion
        mockAuthService.shouldSucceedSign = false
        
        let expectation = self.expectation(description: "signIn should fail")
        
        firebaseAuthManager.signIn(email: "wrong.email@example.com", password: "wrongPassword") { result in
            switch result {
            case .success:
                XCTFail("Expected signIn to fail, but it succeeded")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Sign-in failed")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
}

