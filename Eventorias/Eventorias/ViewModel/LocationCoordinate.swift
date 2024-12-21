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
    @Published
    var coordinates : CLLocationCoordinate2D?
    @Published var latitude : Double = 0.0
    @Published var longitude : Double = 0.0
    init(errorMessage: String? = nil, coordinates: CLLocationCoordinate2D? = nil) {
        self.errorMessage = errorMessage
        self.coordinates = coordinates
    }
    
    @MainActor
    func geocodeAddress(address: String) {
        let formattedAddress = address.replacingOccurrences(of: ",", with: ",")
            .capitalized
        
        guard !formattedAddress.isEmpty else {
            self.errorMessage = "L'adresse est vide."
            self.coordinates = nil
            return
        }

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.coordinates = nil
            } else if let placemark = placemarks?.first, let location = placemark.location ,
                      location.coordinate.latitude != 0.0,
                      location.coordinate.longitude != 0.0 {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude

                // Vérification pour éviter les coordonnées nulles
                if latitude == 0.0 || longitude == 0.0 {
                    self.errorMessage = "Adresse géolocalisée avec des coordonnées invalides."
                    self.coordinates = nil
                    print("Erreur valeurs nulls")
                    print("Voici le résultat : \(location.coordinate)")
                } else {
                    self.coordinates = location.coordinate
                    self.errorMessage = nil
                    print("Validate Graduation")
                    print("Voici le résultat : \(location.coordinate)")

                }
            } else {
                self.errorMessage = "Adresse introuvable."
                self.coordinates = nil
                print("Adresse introuvable")
            }
        }
    }
}
