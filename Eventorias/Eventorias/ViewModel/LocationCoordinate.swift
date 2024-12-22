//
//  CLGeocoder.swift
//  Eventorias
//
//  Created by KEITA on 21/12/2024.
//

import Foundation
import CoreLocation
import PhotosUI

class LocationCoordinate: ObservableObject{
    @Published
    var errorMessage: String?
    @Published var latitude : Double = 0.0
    @Published var longitude : Double = 0.0
    var coordinates : CLLocationCoordinate2D? = nil
    
    init(errorMessage: String? = nil) {
        self.errorMessage = errorMessage
    }
    
    @MainActor
    func geocodeAddress(address: String, completion: @escaping (Result<(Double, Double), Error>) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Erreur lors de la récupération de la localisation : \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let location = placemarks?.first?.location else {
                print("Aucune localisation correspondante trouvée")
                completion(.failure(NSError(domain: "GeocodeError", code: 404, userInfo: [NSLocalizedDescriptionKey: "No matching location found."])))
                return
            }
            
            let coordinate = location.coordinate
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
            print("\nlat: \(coordinate.latitude), long: \(coordinate.longitude)")
            completion(.success((coordinate.latitude, coordinate.longitude)))
        }
    }

}
