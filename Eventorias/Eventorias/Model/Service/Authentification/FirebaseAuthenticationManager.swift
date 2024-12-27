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

class FirebaseAuthenticationManager {
      let authService: AuthService
      let firestoreService: FirestoreService

    init(authService: AuthService, firestoreService: FirestoreService) {
        self.authService = authService
        self.firestoreService = firestoreService
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        authService.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let userID):
                self?.firestoreService.fetchUserData(userID: userID) { fetchResult in
                    switch fetchResult {
                    case .success(let data):
                        if let user = User(from: data) {
                            completion(.success(user))
                        } else {
                            completion(.failure(NSError(
                                domain: "UserDataError",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid user data."]
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
        authService.createUser(email: email, password: password) { [weak self] result in
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
                            completion(.success(user))
                        } else {
                            completion(.failure(NSError(
                                domain: "UserDataError",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Failed to create user object."]
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
