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
    func geocodeAddress(address : String,completion:@escaping((CLLocationCoordinate2D) -> Void)){
        
        CLGeocoder().geocodeAddressString(address){ ( placemark, error ) in
            completion(placemark?.first?.location?.coordinate ?? CLLocationCoordinate2D())
        }
        
    }
}
