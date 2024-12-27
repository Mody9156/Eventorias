//
//  AuthServiceProtocols.swift
//  Eventorias
//
//  Created by KEITA on 27/12/2024.
//

import Foundation

protocol AuthService {
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func createUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
}

protocol FirestoreService {
    func saveUserData(userID: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void)
    func fetchUserData(userID: String, completion: @escaping (Result<[String: Any], Error>) -> Void)
}
