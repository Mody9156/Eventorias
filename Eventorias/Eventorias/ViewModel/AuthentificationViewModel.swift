//
//  AuthentificationViewModel.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class AuthentificationViewModel : ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated : Bool = false
    
    func login(email : String,password:String) {
        //Validation du mail et du mot de passe
        guard !email.isEmpty, !password.isEmpty else {
                   self.errorMessage = "Veuillez remplir tout les champs."
            print(String(describing:errorMessage))
                   return
               }
        //Connexion avec Firebase
        Auth.auth().signIn(withEmail: email, password: password){ result , error in
            if let error = error {
                // Gestion des erreurs de connexion
                self.errorMessage = error.localizedDescription
                self.isAuthenticated = false
            } else {
                // Connexion réussie
                self.errorMessage = nil
                self.isAuthenticated = true
                print("Graduation")
            }
        }
    }
    
    func registerUser(email:String,password:String) {
        
        guard !email.isEmpty, !password.isEmpty else {
                   self.errorMessage = "L'email ou le mot de passe ne peuvent pas être vides."
                   return
               }
        //Création d'un compte utilisateur
        Auth.auth().createUser(withEmail: email, password: password){ result , error in
            if let error = error  {
                self.errorMessage = error.localizedDescription
                print("Voici votre erreur : \(self.errorMessage ?? "Erreur inconnue")")
            }else{
                self.errorMessage = nil
                print("Utilisateur créé avec succès!")
            }
        }
    }
}
