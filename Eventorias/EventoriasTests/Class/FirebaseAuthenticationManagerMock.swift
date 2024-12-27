//
//  FirebaseAuthenticationManagerMock.swift
//  EventoriasTests
//
//  Created by KEITA on 27/12/2024.
//

import XCTest
@testable import Eventorias
class FirebaseAuthenticationManagerMock: FirebaseAuthenticationManager {

    let signCalled = false
    var signResult : Result<User,Error>!

}
