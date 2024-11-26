//
//  AuthentificationViewModel.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import Foundation
import FirebaseAuth

class AuthentificationViewModel : ObservableObject {
    @Published var errorMessage: String? = nil

    func login(email : String){
        
        Auth.auth().fetchSignInMethods(forEmail: email){ result , error in
            if let error = error  {
                self.errorMessage = error.localizedDescription
                print("Voici votre erreur : \(self.errorMessage ?? "Erreur inconnue")")
            }else{
                self.errorMessage = nil
                print("L'email est déjà enregistré, vous pouvez vous connecter.")
            }
        }
    }
    
    func registerUser(email:String,password:String){
        
        guard !email.isEmpty, !password.isEmpty else {
                   self.errorMessage = "L'email ou le mot de passe ne peuvent pas être vides."
                   return
               }
        
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
