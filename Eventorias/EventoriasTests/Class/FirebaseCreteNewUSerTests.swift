//
//  FirebaseAuthenticationManagerTests.swift
//  EventoriasTests
//
//  Created by KEITA on 27/12/2024.
//

import XCTest
@testable import Eventorias
class FirebaseCreteNewUSerTests : ProtocolsFirebaseData{
    
    
    var signCalled = false
    var signResult : Result<User,Error>!
    
    
    func signIn(email: String, password: String, completion: @escaping (Result<Eventorias.User, Error>) -> Void) {
        signCalled = true
        completion(signResult)
    }
    
    func createUser(email: String, password: String, firstName: String, lastName: String, picture: String, completion: @escaping (Result<Eventorias.User, Error>) -> Void) {
        signCalled = true
        completion(signResult)
    }
    
}
