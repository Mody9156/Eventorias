//
//  AuthService.swift
//  Eventorias
//
//  Created by KEITA on 27/12/2024.
//

import Foundation
import Foundation

protocol AuthService {
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func createUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
}
