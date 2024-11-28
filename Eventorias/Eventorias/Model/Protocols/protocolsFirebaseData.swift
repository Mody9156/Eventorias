//
//  DataProtocols.swift
//  Eventorias
//
//  Created by KEITA on 28/11/2024.
//

import Foundation

protocol protocolsFirebaseData{
    func login(email : String,password:String)
    func registerUser(email:String,password:String)
}
