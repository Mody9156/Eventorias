//
//  DetailView.swift
//  Eventorias
//
//  Created by KEITA on 13/12/2024.
//

import Foundation

class UserDetailViewModel: ObservableObject{
    
    @Published
    var eventEntry : [EventEntry]
    private let listViewModel : ListViewModel
    private var googleMapView : GoogleMapView
    
    init(eventEntry: [EventEntry],listViewModel : ListViewModel,googleMapView : GoogleMapView) {
        self.eventEntry = listViewModel.eventEntry
        self.googleMapView = googleMapView
        self.listViewModel = listViewModel
    }
    
    enum Failure: Error {
        case invalidMaps,missingAPIKey
    }
    
    func formatHourString(_ hour:Date) -> String{
        let date = Date.stringFromHour(hour)
        return date
    }
    func formatDateString(_ date:Date) -> String {
        let date = Date.stringFromDate(date)
        return date
    }
    //Config Key
    func loadAPIKey() throws -> String {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path) as? [String: Any],
           let apiKey = config["API_KEY"] as? String {
            return apiKey
        }
        throw Failure.missingAPIKey
    }
    func showMapsStatic( Latitude:Double, Longitude:Double) async throws -> Data {
        do{
            let api =  try loadAPIKey()
            let data = try await googleMapView.showMapsWithURLRequest(Latitude, Longitude, api)
            return data
        }catch{
            throw Failure.invalidMaps
        }
    }
}
