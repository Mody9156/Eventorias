//
//  AuthentificationViewModel.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import Foundation
import FirebaseAuth

class AuthentificationViewModel : ObservableObject {
    
    func login(email : String){
        
        Auth.auth().fetchSignInMethods(forEmail: email){ result , error in
            if error != nil {
                let error = error?.localizedDescription
                print("Voici votre erreur : \(error)")
            }else{
                print("Great")
            }
        }
    }
    
}
