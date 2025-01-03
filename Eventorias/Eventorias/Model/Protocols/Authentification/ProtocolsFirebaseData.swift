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

