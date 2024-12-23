//
//  DataProtocols.swift
//  Eventorias
//
//  Created by KEITA on 28/11/2024.
//

import Foundation

protocol ProtocolsFirebaseData{
    func signIn(email : String, password:String, completion:@escaping(Result<Any, Error>)-> Void)
    func createUser(email:String, password:String, firtName:String, lastName:String, completion:@escaping(Result<Any,Error>)-> Void)
}
