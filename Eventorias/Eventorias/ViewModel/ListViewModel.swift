//
//  ListViewModel.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation

class ListViewModel : ObservableObject {
    
    func formatDateString(eventEntry:EventEntry) -> String {
        let date = Date.stringFromDate(eventEntry.dateCreation)
        
        return date
    }
    
}
