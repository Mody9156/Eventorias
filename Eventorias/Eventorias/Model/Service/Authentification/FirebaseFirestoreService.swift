//
//  FirebaseFirestoreService.swift
//  Eventorias
//
//  Created by KEITA on 27/12/2024.
//
import FirebaseAuth
import FirebaseFirestore

class FirebaseFirestoreService: FirestoreService {
    private let db = Firestore.firestore()

    func saveUserData(userID: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userID).setData(data) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }

    func fetchUserData(userID: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
              completion(.failure(NSError(
                  domain: "AuthError",
                  code: -1,
                  userInfo: [NSLocalizedDescriptionKey: "Utilisateur non authentifié."]
              )))
              return
          }

          // Vérification si l'ID utilisateur correspond à l'utilisateur authentifié
          if currentUser.uid != userID {
              completion(.failure(NSError(
                  domain: "AuthError",
                  code: -1,
                  userInfo: [NSLocalizedDescriptionKey: "L'utilisateur authentifié n'est pas celui demandé."]
              )))
              return
          }
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = document?.data() else {
                completion(.failure(NSError(
                    domain: "FirestoreError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "No user data found."]
                )))
                return
            }
            completion(.success(data))
        }
    }
}
