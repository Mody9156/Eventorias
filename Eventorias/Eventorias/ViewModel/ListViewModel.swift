//
//  ListViewModel.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation
import Firebase

class ListViewModel : ObservableObject {
    enum FilterOption: String, CaseIterable {
        case noFilter
        case date
        case category
    }
    
    
    @Published
    var FilterOption : FilterOption? = .noFilter
    @Published
    var errorMessage :String? = ""
    @Published
    var eventEntry : [EventEntry] = []
    
    private var eventoriasRepository : EventListRepresentable
    
    init(eventoriasRepository : EventListRepresentable = EventoriasRepository()) {
        self.eventoriasRepository = eventoriasRepository
    }
    
    func formatDateString(_ date:Date) -> String {
        let date = Date.stringFromDate(date)
        return date
    }
   
    
    @MainActor
    func getAllProducts() async throws {
        self.eventEntry = try await eventoriasRepository.getAllProducts()
    }
    
    @MainActor
    // verifier l'incrémentation
    func filterSelected(option : FilterOption) async throws {
        self.FilterOption = option
        
        switch option {
        case .noFilter :
            self.eventEntry = try await eventoriasRepository.getAllProducts()
            print("Produits récupérés sans filtre. Nombre de produits : \(self.eventEntry.count)")
            print("Données : \(self.eventEntry)")  // Affiche les données récupérées
        case .category :
            self.eventEntry = try await eventoriasRepository.getAllProductsSortedByCategory()
            print("Produits récupérés triés par catégorie. Nombre de produits : \(self.eventEntry.count)")
            print("Données : \(self.eventEntry)")  // Affiche les données récupérées
        case .date:
            self.eventEntry = try await eventoriasRepository.getAllProductsSortedByDate()
            print("Produits récupérés triés par date. Nombre de produits : \(self.eventEntry.count)")
            print("Données : \(self.eventEntry)")  // Affiche les données récupérées
        }
    }
    
    func filterTitle(_ searchText:String) -> [EventEntry]{
            if searchText.isEmpty{
                return eventEntry
            }else{
                return eventEntry.filter {title in
                    title.title.localizedStandardContains(searchText)
                }
            }
    }
}
