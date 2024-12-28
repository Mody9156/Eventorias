//
//  MockFirebaseAuthenticationManager.swift
//  EventoriasTests
//
//  Created by KEITA on 28/12/2024.
//
import Foundation
@testable import Eventorias
class MockFirebaseAuthenticationManager: FirebaseAuthenticationManager {
    
    var mockSignInResult: Result<User, Error>?
    var mockCreateUserResult: Result<User, Error>?
    
    override func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        if let result = mockSignInResult {
            completion(result)
        }
    }
    
    override func createUser(email: String, password: String, firstName: String, lastName: String, picture: String, completion: @escaping (Result<User, Error>) -> Void) {
        if let result = mockCreateUserResult {
            completion(result)
        }
    }
}
