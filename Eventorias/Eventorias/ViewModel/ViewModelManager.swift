//
//  MainAuth.swift
//  Eventorias
//
//  Created by KEITA on 29/11/2024.
//

import Foundation

class ViewModelManager:ObservableObject {
    @Published var isAuthenticated : Bool
    private var eventListRepresentable: EventListRepresentable
    
    init(eventListRepresentable: EventListRepresentable = ListRepository(firestoreService: FirestoreServiceEvents())){
        isAuthenticated = false
        self.eventListRepresentable = eventListRepresentable
    }
    
    
    var loginViewModel : LoginViewModel {
        
        return LoginViewModel ({ [weak self] in
            self?.isAuthenticated = true
        }, firebaseAuthenticationManager:FirebaseAuthenticationManager())
    }
    
    var listViewModel : ListViewModel {
        return ListViewModel(eventListRepresentable: eventListRepresentable)
    }
    
}
