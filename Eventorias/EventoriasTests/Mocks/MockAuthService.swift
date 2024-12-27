//
//  MockAuthService.swift
//  EventoriasTests
//
//  Created by KEITA on 27/12/2024.
//

import XCTest
@testable import Eventorias

class MockAuthService : AuthService{
    var shouldSucceedSign = true
    var shouldSucceedCreateUser = true
    
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldSucceedSign {
            completion(.success("mockUserID"))
        }else{
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sign-in failed"])))

        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldSucceedSign {
            completion(.success("mockUserID"))
        }else{
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User creation failed"])))

        }
    }
    

    

}
