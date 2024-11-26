//
//  AuthentificationViewModel.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import Foundation
import FirebaseAuth

class AuthentificationViewModel : ObservableObject {
    
    func login(_ email : String ,password : String){
        
        Auth.auth().signIn(withEmail: email, password: password){ result , error in
            if error != nil {
                print("error")
            }else{
                print("Great")
            }
        }
    }
    
}
