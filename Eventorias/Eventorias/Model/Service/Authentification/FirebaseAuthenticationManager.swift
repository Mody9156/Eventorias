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

class FirebaseAuthenticationManager :ProtocolsFirebaseData {
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password){ result , error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let userId = result?.user else {
                completion(.failure(NSError(
                            domain: "AuthError",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "User authentication failed."]
                        )))
                return
            }
            
            self.fetchUserData(userID: userId.uid){ fetchResult in
                switch fetchResult {
                case .success(let data):
                    print("User data fetched: \(data)")
                    completion(.success(data)) // Retourner les données récupérées
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
        }
    }
    
    func createUser(email: String, password: String, firtName: String, lastName: String, completion: @escaping (Result<Any, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password){ result , error in
            if let error = error  {
                completion(.failure(error))
            }
            
            // Retourner une erreur générique si l'utilisateur est nul
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "CreateError", code: -1,userInfo: [NSLocalizedDescriptionKey:"Unknown error occurred."])))
                return
            }
            
            // Mettre à jour le profil Firebase
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = "\(firtName) \(lastName)"
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "firstName": firtName,
                    "lastName": lastName,
                    "email": email,
                    "uid": user.uid
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        self.fetchUserData(userID: user.uid){ fetchResult in
                            switch fetchResult {
                            case .success(let data):
                                print("User data fetched: \(data)")
                                completion(.success(data)) // Retourner les données récupérées
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func fetchUserData(userID: String, completion: @escaping (Result<User, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = document?.data() else {
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found."])))
                return
            }
            if let user =  User(from: data){
                completion(.success(user))
            }else{
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data."])))
            }
        }
    }
}
