//
//  AuthentificationViewModel.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import Foundation
import FirebaseAuth
import PhotosUI

class LoginViewModel : ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated: Bool = false
    @Published var onLoginSucceed: (() -> ())
    
    let firebaseAuthenticationManager: FirebaseAuthenticationManager
    
    init(_ callback:@escaping (() -> ()), firebaseAuthenticationManager: FirebaseAuthenticationManager) {
        self.onLoginSucceed = callback
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
    }
    
    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Veuillez remplir tous les champs."
            print(String(describing: errorMessage))
            return
        }
        
        // Connexion via Firebase
        firebaseAuthenticationManager.signIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }  // Éviter les fuites de mémoire
            
            switch result {
            case .success(let user):
                self.errorMessage = nil
                self.isAuthenticated = true
                self.onLoginSucceed()
                print("user: \(user)")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isAuthenticated = false
            }
        }
    }
    
    func registerUser(email: String, password: String, firstName: String, lastName: String, picture: String) {
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "L'email ou le mot de passe ne peuvent pas être vides."
            return
        }
        
        firebaseAuthenticationManager.createUser(email: email, password: password, firstName: firstName, lastName: lastName, picture: picture) { result in
            switch result {
            case .success(let user):
                self.errorMessage = nil
                print("Utilisateur \(user) a été créé avec succès!")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Voici votre erreur : \(self.errorMessage ?? "Erreur inconnue")")
            }
        }
    }
}
