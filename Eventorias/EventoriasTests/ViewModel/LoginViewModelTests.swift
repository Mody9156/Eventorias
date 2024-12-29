//
//  LoginViewModelTests.swift
//  EventoriasTests
//
//  Created by KEITA on 28/12/2024.
//
import XCTest
@testable import Eventorias

class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var mockFirebaseAuthenticationManager: MockFirebaseAuthenticationManager!
    
    override func setUp() {
        super.setUp()
        
        mockFirebaseAuthenticationManager = MockFirebaseAuthenticationManager()
        
        viewModel = LoginViewModel ({}, firebaseAuthenticationManager: mockFirebaseAuthenticationManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockFirebaseAuthenticationManager = nil
        super.tearDown()
    }
    
    func testLoginWithEmptyFields() {

        viewModel.login(email: "", password: "validPassword")
        XCTAssertEqual(viewModel.errorMessage, "Veuillez remplir tous les champs.")
        
        viewModel.login(email: "validEmail@example.com", password: "")
        XCTAssertEqual(viewModel.errorMessage, "Veuillez remplir tous les champs.")
    }
    
    func testLoginSuccess() {
        let data: [String: Any] = [
            "firstName": "firstName",
            "lastName": "lastName",
            "email": "validEmail@example.com",
            "uid": "123",
            "picture": "picture"
        ]
        guard let success = User(from: data) else{
            return
        }
        mockFirebaseAuthenticationManager.mockSignInResult = .success(success)
        
        
        let expectation = self.expectation(description: "Login succeed")
        
        viewModel.onLoginSucceed = {
            expectation.fulfill()
        }
        
        viewModel.login(email: "validEmail@example.com", password: "validPassword")
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.isAuthenticated)
    }
    
    func testLoginFailure() {

        mockFirebaseAuthenticationManager.mockSignInResult = .failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"]))
        
        viewModel.login(email: "validEmail@example.com", password: "wrongPassword")
        
        XCTAssertEqual(viewModel.errorMessage, "Invalid credentials")
        XCTAssertFalse(viewModel.isAuthenticated)
    }
    
    func testRegisterUserWithEmptyFields() {
       
        viewModel.registerUser(email: "", password: "validPassword", firstName: "John", lastName: "Doe", picture: "pictureURL")
        XCTAssertEqual(viewModel.errorMessage, "L'email ou le mot de passe ne peuvent pas être vides.")
        
        viewModel.registerUser(email: "validEmail@example.com", password: "", firstName: "John", lastName: "Doe", picture: "pictureURL")
        XCTAssertEqual(viewModel.errorMessage, "L'email ou le mot de passe ne peuvent pas être vides.")
    }
    
    func testRegisterUserSuccess() {
        let data: [String: Any] = [
            "firstName": "firstName",
            "lastName": "lastName",
            "email": "validEmail@example.com",
            "uid": "123",
            "picture": "picture"
        ]
        guard let success = User(from: data) else{
            return
        }
        mockFirebaseAuthenticationManager.mockCreateUserResult = .success(success)
        
        viewModel.registerUser(email: "validEmail@example.com", password: "validPassword", firstName: "John", lastName: "Doe", picture: "pictureURL")
        
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testRegisterUserFailure() {

        mockFirebaseAuthenticationManager.mockCreateUserResult = .failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        
        viewModel.registerUser(email: "validEmail@example.com", password: "validPassword", firstName: "John", lastName: "Doe", picture: "pictureURL")
        
        XCTAssertEqual(viewModel.errorMessage, "Server error")
    }
}
