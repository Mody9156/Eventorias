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
    
    init(errorMessage: String? = nil) {
        self.errorMessage = errorMessage
    }
    
    func geocodeAddress(address: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            guard let self = self else {return}
            if let error = error {
                self.errorMessage = error.localizedDescription
                print("Geocoding failed with error: \(error.localizedDescription)")
            }
            
            guard let placemark = placemarks?.first,
                  let location = placemark.location  else {
                print("No valid placemark or location found for the address.")
                return
            }
            
            DispatchQueue.main.async {
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                print("Geocoding success: Latitude: \(self.latitude), Longitude: \(self.longitude)")
            }
        }
    }
}
