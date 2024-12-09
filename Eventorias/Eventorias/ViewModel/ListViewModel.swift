//
//  ListViewModel.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation
import Firebase

class ListViewModel : ObservableObject {
    enum FilterOption : String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
    }
    
    @Published
    var filter : FilterOption? = nil
   
    @Published
    var errorMessage :String? = ""
    
    @Published
    var eventEntry = EventEntry.eventEntry
    
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
        
    func fetchData(){
        eventoriasRepository.subscribe()
    }
    
    func filterSelected(option : FilterOption) async throws {
        switch option {
        case .noFilter :
            self.eventEntry = try await eventoriasRepository.getAllProducts()
        case .priceHigh :
            self.eventEntry = try await eventoriasRepository.getAllProductsSortedByDate(descending: true)
        case .priceLow :
            self.eventEntry = try await eventoriasRepository.getAllProductsSortedByDate(descending: false)
        }
        DispatchQueue.main.async {
            self.filter = option

        }
    }
    
}
