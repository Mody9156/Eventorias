//
//  ListViewModel.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation

class ListViewModel : ObservableObject {
    
   private var eventoriasRepository : EventoriasRepository = EventoriasRepository()
    
    func formatDateString(eventEntry:EventEntry) -> String {
        let date = Date.stringFromDate(eventEntry.dateCreation)
        
        return date
    }
    
    func addEventEntry(_ eventEntry : EventEntry )-> String{
        do{
            
        } catch{
            
        }
    }
    
}
