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
    var FilterOption : FilterOption? = nil
   
    @Published
    var errorMessage :String? = ""
    
    @Published
    var eventEntry : [EventEntry]
    
    init( eventEntry: [EventEntry]) {
           self.eventEntry = eventEntry
    }
   
    
    private var eventoriasRepository : EventoriasRepository = EventoriasRepository()
    
    func formatDateString(_ date:Date) -> String {
        let date = Date.stringFromDate(date)
        return date
    }
    
    func formatHourString(_ hour:Date) -> String{
        let date = Date.stringFromHour(hour)
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
    
    func tryEvent(keyword: String) {
        eventoriasRepository.searchEvents(by: keyword) { [weak self]  result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    self?.eventEntry = events
                case .failure(let error):
                    print("Error :\(error.localizedDescription)")
                    self?.eventEntry = []
                }
            }
        }
    }
        
    func getAllProducts() async throws  {
        self.eventEntry = try await eventoriasRepository.getAllProducts()
    }
  
    func fetchData(){
        eventoriasRepository.subscribe()
    }
    
    func filterSelected(option : FilterOption) async throws {
        
        DispatchQueue.main.async {
            self.FilterOption = option
        }
        
        switch option {
        case .noFilter :
            self.eventEntry = try await eventoriasRepository.getAllProductsSortedByDate()
        case .date :
            self.eventEntry = try await eventoriasRepository.getAllProductsSortedByDate()
        case .category :
            self.eventEntry = try await eventoriasRepository.getAllProductsSortedByCategory()
        }
        
        
        
        
    }
}
