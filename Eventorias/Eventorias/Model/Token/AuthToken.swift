//
//  AuthToken.swift
//  Eventorias
//
//  Created by KEITA on 29/11/2024.
//

import Foundation

struct AuthToken {
    private static let tokenKey = "authToken"
    
    static func addToken(_ token :String ) -> String {
        UserDefaults.standard.set(token, forKey: tokenKey)
        return token
    }
    
    static func retrieve() -> String?{
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    static func dete(){
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
