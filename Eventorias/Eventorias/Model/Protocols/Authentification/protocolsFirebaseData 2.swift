//
//  DataProtocols.swift
//  Eventorias
//
//  Created by KEITA on 28/11/2024.
//

import Foundation

protocol protocolsFirebaseData{
    func signIn(email : String, password:String, completion:@escaping(Result<Any, Error>)-> Void)
    func createUser(email:String, password:String, completion:@escaping(Result<Any,Error>)-> Void)
}
