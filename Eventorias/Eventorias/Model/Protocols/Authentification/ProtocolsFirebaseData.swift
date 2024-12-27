//
//  DataProtocols.swift
//  Eventorias
//
//  Created by KEITA on 28/11/2024.
//

import Foundation

protocol ProtocolsFirebaseData{
    func signIn(email : String, password:String, completion:@escaping(Result<User, Error>)-> Void)
    func createUser(email: String, password: String, firstName: String, lastName: String, picture: String, completion: @escaping (Result<User, Error>) -> Void)
}

protocol FirestoreService {
    func saveUserData(userID: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void)
    func fetchUserData(userID: String, completion: @escaping (Result<[String: Any], Error>) -> Void)
}
