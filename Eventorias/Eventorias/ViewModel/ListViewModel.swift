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
    @Published
    var isError : Bool = false
    
    private var eventListRepresentable : EventListRepresentable
    
    init(eventListRepresentable : EventListRepresentable = ListRepository(firestoreService: FirestoreServiceEvents())) {
        self.eventListRepresentable = eventListRepresentable
    }
    
    func formatDateString(_ date:Date) -> String {
        let date = Date.stringFromDate(date)
        return date
    }
    
    @MainActor
    func getAllProducts() async throws {
        do {
            self.eventEntry = try await eventListRepresentable.getAllProducts()
            self.isError = false
        }catch{
            self.isError = true
            throw error
        }
    }
    
    @MainActor
    func filterSelected(option : FilterOption) async throws {
        self.FilterOption = option
        
        switch option {
        case .noFilter :
            self.eventEntry = try await eventListRepresentable.getAllProducts()
        case .category :
            self.eventEntry = try await eventListRepresentable.getAllProductsSortedByCategory()
        case .date:
            self.eventEntry = try await eventListRepresentable.getAllProductsSortedByDate()
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
