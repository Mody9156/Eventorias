//
//  MainAuth.swift
//  Eventorias
//
//  Created by KEITA on 29/11/2024.
//

import Foundation

class ViewModelManager:ObservableObject {
    @Published var isAuthenticated : Bool
    private var eventoriasRepository: EventListRepresentable
    
    init(eventoriasRepository: EventListRepresentable = ListRepository()){
        isAuthenticated = false
        self.eventoriasRepository = eventoriasRepository
    }
    
    
    var loginViewModel : LoginViewModel {
        return LoginViewModel { [weak self] in
            self?.isAuthenticated = true
        }
    }
    
    var listViewModel : ListViewModel {
        return ListViewModel(eventoriasRepository: eventoriasRepository)
    }
    
}
