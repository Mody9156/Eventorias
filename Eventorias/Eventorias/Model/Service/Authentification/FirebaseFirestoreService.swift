//
//  FirebaseFirestoreService.swift
//  Eventorias
//
//  Created by KEITA on 27/12/2024.
//
import FirebaseAuth

class FirebaseAuthService: AuthService {
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let userID = result?.user.uid else {
                completion(.failure(NSError(
                    domain: "AuthError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user ID."]
                )))
                return
            }
            completion(.success(userID))
        }
    }

    func createUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let userID = result?.user.uid else {
                completion(.failure(NSError(
                    domain: "CreateUserError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to create user."]
                )))
                return
            }
            completion(.success(userID))
        }
    }
}
