//
//  User.swift
//  Eventorias
//
//  Created by KEITA on 23/12/2024.
//

// User.swift
// Eventorias
//
// Created by KEITA on 23/12/2024.
//

import Foundation

struct User {
    let firstName: String
    let lastName: String
    let email: String
    let uid: String
    
    // Vous pouvez ajouter un init pour créer un utilisateur à partir d'un dictionnaire, si nécessaire.
    init(firstName: String, lastName: String, email: String, uid: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.uid = uid
    }
    
    // Un init à partir d'un dictionnaire Firestore peut être ajouté ici si vous en avez besoin
    init?(from dictionary: [String: Any]) {
        guard let firstName = dictionary["firstName"] as? String,
              let lastName = dictionary["lastName"] as? String,
              let email = dictionary["email"] as? String,
              let uid = dictionary["uid"] as? String else {
                  return nil
              }
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.uid = uid
    }
}
