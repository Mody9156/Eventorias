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
    
    func signIn(email: String, password: String, completion: @escaping (Result<Any, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password){ result , error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let result = result {
                completion(.success(result))
                
            }else{
                completion(.failure(NSError(
                    domain: "AuthError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey :"Unknown error occurred."]
                )))
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
            }
            
            
            
        }
    }
}
