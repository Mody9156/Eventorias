//
//  ListViewModel.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation

class ListViewModel : ObservableObject {
    @Published
    var errorMessage :String? = ""
    
    @Published
    var eventEntry = EventEntry.eventEntry
    
    private var eventoriasRepository : EventoriasRepository = EventoriasRepository()
    
    func formatDateString(eventEntry:EventEntry) -> String {
        let date = Date.stringFromDate(eventEntry.dateCreation)
        
        return date
    }
    
    @MainActor
    func addEventEntry(_ eventEntry : EventEntry ) async throws {
        
        do{
            try eventoriasRepository.addEvenement(eventEntry)
            errorMessage = nil
            
        } catch{
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func tryEvent()  {
        eventoriasRepository.tryEvenement()
        errorMessage = nil
    }
}
