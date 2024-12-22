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
    func geocodeAddress(address : String){
        let geocoder = CLGeocoder()
             geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                 if error != nil {
                     print("Failed to retrieve location")
                     return
                 }
                 
                 var location: CLLocation?
                 
                 if let placemarks = placemarks, placemarks.count > 0 {
                     location = placemarks.first?.location
                 }
                 
                 if let location = location {
                     let coordinate = location.coordinate
                     print("\nlat: \(coordinate.latitude), long: \(coordinate.longitude)")
                     self.latitude = coordinate.latitude
                     self.longitude = coordinate.longitude
                 }
                 else
                 {
                     print("No Matching Location Found")
                 }
             })
    }
}
