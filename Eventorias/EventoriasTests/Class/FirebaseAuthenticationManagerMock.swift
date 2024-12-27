//
//  FirebaseAuthenticationManagerMock.swift
//  EventoriasTests
//
//  Created by KEITA on 27/12/2024.
//

import XCTest
@testable import Eventorias
class FirebaseAuthenticationManagerMock: FirebaseAuthenticationManager {

    var signCalled = false
    var signResult : Result<User,Error>!
    
    override func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        signCalled = true
        completion(signResult)
    }

    override func fetchUserData(userID: String, completion: @escaping (Result<User, Error>) -> Void) {
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
        completion(.success(mockUser))
        
    }
   
}
