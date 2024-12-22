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
    func geocodeAddress(address : String,completion:@escaping(Result<CLLocationCoordinate2D, Error>) -> Void){
        
        CLGeocoder().geocodeAddressString(address){ ( placemarks, error ) in
//            completion(placemark?.first?.location?.coordinate ?? CLLocationCoordinate2D())
            if let error = error {
                completion(.failure(error))
            }else if let location = placemarks?.first?.location?.coordinate {
                completion(.success(location))
            }else{
                completion(.failure(NSError(domain: "GeocoderError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No location found."])))
            }
            
        }
        
    }
}
