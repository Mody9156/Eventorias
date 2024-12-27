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
    
    
}
