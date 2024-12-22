//
//  GoogleMapView.swift
//  Eventorias
//
//  Created by KEITA on 13/12/2024.
//

import Foundation

class GoogleMapView {
    let httpService : HTTPService
    
    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }
    
    enum AuthenticationError: Error {
        case invalidData
        case invalidResponse
        case invalidUrl
    }
    
    func fetchURLRequest(_ latitude: Double,_ longitude: Double, _ key: String) -> URLRequest {
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/staticmap?center=\(latitude),\(longitude)&zoom=12&size=149x72&maptype=roadmap&key=\(key)") else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func showMapsWithURLRequest(_ latitude: Double, _ longitude: Double, _ key: String) async throws -> Data {
        guard latitude != 0 && longitude != 0 else {
            throw AuthenticationError.invalidData
        }

        let request = fetchURLRequest(latitude, longitude, key)
        let (data, response) = try await httpService.fetchRequest(request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        guard !data.isEmpty else {
            throw AuthenticationError.invalidData
        }

        return data
    }
}
