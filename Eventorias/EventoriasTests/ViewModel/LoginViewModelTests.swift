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
        
        // Initialisation du mock de FirebaseAuthenticationManager
        mockFirebaseAuthenticationManager = MockFirebaseAuthenticationManager()
        
        // Initialisation de LoginViewModel avec un callback vide
        viewModel = LoginViewModel {
            // Callback vide pour l'instant
        }, firebaseAuthenticationManager: mockFirebaseAuthenticationManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockFirebaseAuthenticationManager = nil
        super.tearDown()
    }
    
    // Test si la méthode login gère les champs vides
    func testLoginWithEmptyFields() {
        // Test pour un email vide
        viewModel.login(email: "", password: "validPassword")
        XCTAssertEqual(viewModel.errorMessage, "Veuillez remplir tous les champs.")
        
        // Test pour un mot de passe vide
        viewModel.login(email: "validEmail@example.com", password: "")
        XCTAssertEqual(viewModel.errorMessage, "Veuillez remplir tous les champs.")
    }
    
    // Test si la méthode login gère une connexion réussie
    func testLoginSuccess() {
        // Configurer le mock pour réussir la connexion
        mockFirebaseAuthenticationManager.mockSignInResult = .success(User(id: "123", email: "validEmail@example.com"))
        
        let expectation = self.expectation(description: "Login succeed")
        
        // Définir le callback
        viewModel.onLoginSucceed = {
            expectation.fulfill()
        }
        
        // Appeler login avec des données valides
        viewModel.login(email: "validEmail@example.com", password: "validPassword")
        
        // Attendre que l'attente se termine
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.isAuthenticated)
    }
    
    // Test si la méthode login gère une erreur de connexion
    func testLoginFailure() {
        // Configurer le mock pour échouer la connexion
        mockFirebaseAuthenticationManager.mockSignInResult = .failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"]))
        
        // Appeler login avec des données valides
        viewModel.login(email: "validEmail@example.com", password: "wrongPassword")
        
        XCTAssertEqual(viewModel.errorMessage, "Invalid credentials")
        XCTAssertFalse(viewModel.isAuthenticated)
    }
    
    // Test si la méthode registerUser gère l'inscription avec un email et un mot de passe vides
    func testRegisterUserWithEmptyFields() {
        // Test pour un email vide
        viewModel.registerUser(email: "", password: "validPassword", firstName: "John", lastName: "Doe", picture: "pictureURL")
        XCTAssertEqual(viewModel.errorMessage, "L'email ou le mot de passe ne peuvent pas être vides.")
        
        // Test pour un mot de passe vide
        viewModel.registerUser(email: "validEmail@example.com", password: "", firstName: "John", lastName: "Doe", picture: "pictureURL")
        XCTAssertEqual(viewModel.errorMessage, "L'email ou le mot de passe ne peuvent pas être vides.")
    }
    
    // Test si la méthode registerUser gère une inscription réussie
    func testRegisterUserSuccess() {
        // Configurer le mock pour réussir l'inscription
        mockFirebaseAuthenticationManager.mockCreateUserResult = .success(User(id: "123", email: "validEmail@example.com"))
        
        viewModel.registerUser(email: "validEmail@example.com", password: "validPassword", firstName: "John", lastName: "Doe", picture: "pictureURL")
        
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // Test si la méthode registerUser gère une erreur d'inscription
    func testRegisterUserFailure() {
        // Configurer le mock pour échouer l'inscription
        mockFirebaseAuthenticationManager.mockCreateUserResult = .failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        
        viewModel.registerUser(email: "validEmail@example.com", password: "validPassword", firstName: "John", lastName: "Doe", picture: "pictureURL")
        
        XCTAssertEqual(viewModel.errorMessage, "Server error")
    }
}
