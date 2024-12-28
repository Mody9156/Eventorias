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
//La Classe Principale
class FirebaseAuthenticationManager {
    private let authService: AuthService
    private let firestoreService: FirestoreService

    init(authService: AuthService = FirebaseAuthService(), firestoreService: FirestoreService = FirebaseFirestoreService()) {
        self.authService = authService
        self.firestoreService = firestoreService
    }
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        self.clearUserData()

        authService.signIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userID):
                self.firestoreService.fetchUserData(userID: userID) { fetchResult in
                    switch fetchResult {
                    case .success(let data):
                        if let user = User(from: data) {
                            self.saveUserData(user)
                            completion(.success(user))
                        } else {
                            completion(.failure(NSError(
                                domain: "UserDataError",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Données utilisateur invalides."]
                            )))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
        
    }
    
    func createUser(email: String, password: String, firstName: String, lastName: String, picture: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if methods?.count ?? 0 > 0 {
                completion(.failure(NSError(domain: "EmailError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cet email est déjà utilisé."])))
                return
            }

            // Création de l'utilisateur
            self.authService.createUser(email: email, password: password) { [weak self] result in
                switch result {
                case .success(let userID):
                    let data: [String: Any] = [
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                        "uid": userID,
                        "picture": picture
                    ]
                    self?.firestoreService.saveUserData(userID: userID, data: data) { saveResult in
                        switch saveResult {
                        case .success:
                            if let user = User(from: data) {
                                self?.saveUserData(user)
                                completion(.success(user))
                            } else {
                                completion(.failure(NSError(
                                    domain: "UserDataError",
                                    code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "Échec de la création de l'objet utilisateur."]
                                )))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func saveUserData(_ user: User) {
        // Sauvegarder les informations de l'utilisateur dans UserDefaults
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        UserDefaults.standard.set(user.firstName, forKey: "userFirstName")
        UserDefaults.standard.set(user.lastName, forKey: "userLastName")
        UserDefaults.standard.set(user.picture, forKey: "userPicture")
    }

    private func clearUserData() {
        // Réinitialiser les données utilisateur précédentes dans UserDefaults
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userFirstName")
        UserDefaults.standard.removeObject(forKey: "userLastName")
        UserDefaults.standard.removeObject(forKey: "userPicture")
    }
}
