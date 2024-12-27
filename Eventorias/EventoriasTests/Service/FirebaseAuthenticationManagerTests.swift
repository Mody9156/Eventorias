//
//  FirebaseAuthenticationManagerTests.swift
//  EventoriasTests
//
//  Created by KEITA on 27/12/2024.
//

import XCTest
@testable import Eventorias
final class FirebaseAuthenticationManagerTests: XCTestCase {

    var authManager : FirebaseAuthenticationManager!
    
    override func setUp() {
        super.setUp()
        authManager = FirebaseAuthenticationManager()
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
        guard let user = User(from: <#T##[String : Any]#>)
        waitForExpectations(timeout: 10, handler: nil)

    }
}
