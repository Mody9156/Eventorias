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

}
