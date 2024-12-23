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

    private enum Keys {
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let email = "email"
        static let uid = "uid"
    }

    init?(from dictionary: [String: Any]) {
        guard let firstName = dictionary[Keys.firstName] as? String,
              let lastName = dictionary[Keys.lastName] as? String,
              let email = dictionary[Keys.email] as? String,
              let uid = dictionary[Keys.uid] as? String else {
            return nil
        }
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.uid = uid
    }

    func toDictionary() -> [String: Any] {
        return [
            Keys.firstName: firstName,
            Keys.lastName: lastName,
            Keys.email: email,
            Keys.uid: uid
        ]
    }
}
