//
//  AuthentificationViewModel.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import Foundation
import FirebaseAuth

class LoginViewModel : ObservableObject {
    @Published
    var errorMessage: String? = nil
    @Published
    var isAuthenticated : Bool = false
    @Published
    var onLoginSucceed : (() -> ())
    @Published var email : String = "fdsg"
    @Published var firstName : String = "jack"
    @Published var lastName : String = "fgg"
    
    let firebaseAuthenticationManager : ProtocolsFirebaseData
    
    init(_ callback:@escaping (() -> ()),firebaseAuthenticationManager : ProtocolsFirebaseData = FirebaseAuthenticationManager()) {
        self.onLoginSucceed = callback
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
     
    }
    
    func login(email : String,password:String) {
        //Validation du mail et du mot de passe
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Veuillez remplir tout les champs."
            print(String(describing:errorMessage))
            return
        }
        
        firebaseAuthenticationManager.signIn(email: email, password: password){ [weak self] result in
            guard let self = self else { return }  // Éviter les fuites de mémoire

            switch result {
                // Connexion réussie
            case .success(let result):
                DispatchQueue.main.async {
                    UserDefaults.standard.set(result.email, forKey: "userEmail")
                    UserDefaults.standard.set(result.firstName, forKey: "userFirstName")
                    UserDefaults.standard.set(result.lastName, forKey: "userLastName")
                }
                self.errorMessage = nil
                self.isAuthenticated = true
                print("firstName = \(result.firstName)")
                print("firstName = \(result.lastName)")
                print("Graduation \(result) Vous venez de vous connecter")
                print("lastName from result: \(self.lastName)")

                self.onLoginSucceed()
                break
                // Connexion échoue
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isAuthenticated = false
                break
            }
        }
        
        
    }
    
    func result()->String{
        return "hello \(self.lastName) \(self.firstName) avec le mail \(self.email)"
    }
    
    func registerUser(email:String,password:String,firtName: String,lastName: String) {
        
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "L'email ou le mot de passe ne peuvent pas être vides."
            return
        }
        
        firebaseAuthenticationManager.createUser(email: email, password: password, firtName: firtName, lastName: lastName){ result in
            switch result {
                // Création réussie
            case .success(let result) :
                self.errorMessage = nil
                print("Utilisateur \(result) a été créé avec succès!")
                break
                // Création échoue
            case .failure(let error) :
                self.errorMessage = error.localizedDescription
                print("Voici votre erreur : \(self.errorMessage ?? "Erreur inconnue")")
                break
            }
        }
    }
}
