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
struct User : Codable, Hashable{
    let firstName: String
    let lastName: String
    let email: String
    let uid: String

    // Initialiseur pour la création d'un utilisateur
    init(firstName: String, lastName: String, email: String, uid: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.uid = uid
    }

    // Méthode pour convertir l'objet User en dictionnaire [String: Any]
    func toDictionary() -> [String: Any] {
        return [
            "firstName": self.firstName,
            "lastName": self.lastName,
            "email": self.email,
            "uid": self.uid
        ]
    }

    // Initialiseur pour créer un User à partir d'un dictionnaire Firestore
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
