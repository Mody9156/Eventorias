//
//  MainAuth.swift
//  Eventorias
//
//  Created by KEITA on 29/11/2024.
//

import Foundation

class ViewModelManager:ObservableObject {
    @Published var isAuthenticated : Bool
    
    init(){
       isAuthenticated = false
    }
   
    
    var authentificationViewModel : AuthentificationViewModel {
        return AuthentificationViewModel { [weak self] in
            self?.isAuthenticated = true
        }
    }
    
}
