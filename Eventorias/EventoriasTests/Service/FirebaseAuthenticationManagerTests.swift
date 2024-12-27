//
//  FirebaseAuthenticationManagerTests.swift
//  EventoriasTests
//
//  Created by KEITA on 27/12/2024.
//

import XCTest
@testable import Eventorias
final class FirebaseAuthenticationManagerTests: XCTestCase {
    
    var authManager : FirebaseAuthenticationManagerMock!
    
    override func setUp() {
        super.setUp()
        authManager = FirebaseAuthenticationManagerMock()
    }
    
    override func tearDown() {
        super.tearDown()
        authManager = nil
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
    
    func testSignFailure(){
        authManager.signResult = .failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"]))
        
        let expectation = self.expectation(description: "signIn should complete with failure")
        
        authManager.signIn(email: "wrong.email@example.com", password: "wrongpassword") { result in
            
            switch result {
            case .success(let user):
                XCTFail("Expected failure but got success: \(user)")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Invalid credentials")
                
            }
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0,handler: nil)
    }
    
    func testSignSuccess(){
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
        
        let mockUser = user
        authManager.signResult = .success(mockUser)
        let expectation = self.expectation(description: "signIn should complete successfully")

        authManager.signIn(email: "john.doe@example.com", password: "password") { result in
            switch result {
                       case .success(let user):
                           XCTAssertEqual(user.firstName, "John")
                           XCTAssertEqual(user.lastName, "Doe")
                           XCTAssertEqual(user.email, "john.doe@example.com")
                           XCTAssertEqual(user.uid, "12345")
                           XCTAssertEqual(user.picture, "http://example.com/picture.jpg")
                       case .failure(let error):
                           XCTFail("Expected success but got failure: \(error.localizedDescription)")
                       }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0,handler: nil)
    }
   
//
//    func testCreateSuccess(){
//        let userDict: [String: Any] = [
//                    "firstName": "John",
//                    "lastName": "Doe",
//                    "email": "john.doe@example.com",
//                    "uid": "12345",
//                    "picture": "http://example.com/picture.jpg"
//                ]
//
//        //initialisation de l'object User
//        guard let user = User(from: userDict) else {
//            XCTFail("User initialization failed")
//            return
//        }
//
//        let mockUser = user
//        authManager.signResult = .success(user)
//
//        let expectation = self.expectation(description: "signIn should complete successfully")
//
//        authManager.createUser(email: "John", password: "Doe", firstName: "ohn.doe@example.com", lastName: "Doe", picture: "http://example.com/picture.jpg") { result in
//            switch result {
//            case .success(let user):
//                XCTAssertEqual(user.firstName, "John")
//                XCTAssertEqual(user.lastName, "Doe")
//                XCTAssertEqual(user.email, "john.doe@example.com")
//                XCTAssertEqual(user.uid, "12345")
//                XCTAssertEqual(user.picture, "http://example.com/picture.jpg")
//            case .failure(let error):
//                XCTFail("Expected success but got failure: \(error.localizedDescription)")
//            }
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 1.0,handler: nil)
//    }
    
    
    
    
    
}

