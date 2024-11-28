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
    let firebaseAuthenticationManager : protocolsFirebaseData = FirebaseAuthenticationManager()
    
    func login(email : String,password:String) {
        //Validation du mail et du mot de passe
        guard !email.isEmpty, !password.isEmpty else {
                   self.errorMessage = "Veuillez remplir tout les champs."
            print(String(describing:errorMessage))
                   return
               }
        //Connexion avec Firebase
//        firebaseAuthenticationManager.signIn().signIn(withEmail: email, password: password){ result , error in
//            if let error = error {
//                // Gestion des erreurs de connexion
//                self.errorMessage = error.localizedDescription
//                self.isAuthenticated = false
//            } else {
//                // Connexion réussie
//                self.errorMessage = nil
//                self.isAuthenticated = true
//                print("Graduation")
//            }
           
            
//        }
        firebaseAuthenticationManager.signIn(email: email, password: password){ result in
            switch result {
            case .success(let result):
                self.errorMessage = nil
                self.isAuthenticated = true
                print("Graduation \(result) à été créer avec succée")
                break
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isAuthenticated = false
                break
            }
        }
    }
    
    func registerUser(email:String,password:String) {
        
        guard !email.isEmpty, !password.isEmpty else {
                   self.errorMessage = "L'email ou le mot de passe ne peuvent pas être vides."
                   return
               }
        //Création d'un compte utilisateur
//        Auth.auth().createUser(withEmail: email, password: password){ result , error in
//            if let error = error  {
//                self.errorMessage = error.localizedDescription
//                print("Voici votre erreur : \(self.errorMessage ?? "Erreur inconnue")")
//            }else{
//                self.errorMessage = nil
//                print("Utilisateur créé avec succès!")
//            }
//        }
        
        firebaseAuthenticationManager.createUser(email: email, password: password){ result in
            switch result {
            case .success(let result) :
                self.errorMessage = nil
                print("Utilisateur \(result) a été créé avec succès!")
                break
            case .failure(let error) :
                self.errorMessage = error.localizedDescription
                print("Voici votre erreur : \(self.errorMessage ?? "Erreur inconnue")")
                break
            }
        }
        
        
        
    }
}
