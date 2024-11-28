//
//  FirebaseAuthenticationManager.swift
//  Eventorias
//
//  Created by KEITA on 28/11/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class FirebaseAuthenticationManager :protocolsFirebaseData {
    
    func signIn(email: String, password: String, completion: @escaping (Result<Any, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password){ result , error in
            if let error = error {
                // Gestion des erreurs de connexion

                completion(.failure(error))
            } else {
                // Connexion réussie
                self.errorMessage = nil
                self.isAuthenticated = true
                print("Graduation")
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result<Any, Error>) -> Void) {
        <#code#>
    }
    
    
}
