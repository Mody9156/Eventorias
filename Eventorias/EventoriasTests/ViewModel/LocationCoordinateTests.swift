//
//  LocationCoordinateTests.swift
//  EventoriasTests
//
//  Created by KEITA on 29/12/2024.
//
import XCTest
import CoreLocation
@testable import Eventorias

class LocationCoordinateTests: XCTestCase {
    
    var locationCoordinate: LocationCoordinate!
    
    override func setUp() {
        super.setUp()
        locationCoordinate = LocationCoordinate()
    }
    
    override func tearDown() {
        locationCoordinate = nil
        super.tearDown()
    }
    
    @MainActor func testGeocodeAddress_ValidAddress() {
        let expectation = self.expectation(description: "Géocodage réussi")
        
        let address = "Paris, France"
        
        locationCoordinate.geocodeAddress(address: address) { result in
            switch result {
            case .success(let coordinates):

                XCTAssertGreaterThan(coordinates.0, 0.0, "Latitude doit être supérieure à 0")
                XCTAssertGreaterThan(coordinates.1, 0.0, "Longitude doit être supérieure à 0")
            case .failure(let error):
                XCTFail("Échec du géocodage pour une adresse valide : \(error.localizedDescription)")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    @MainActor
    func testGeocodeAddress_InvalidAddress() {
        let expectation = self.expectation(description: "Géocodage échoué")

        let address = "Invalid Address, XYZ"

        locationCoordinate.geocodeAddress(address: address) { result in
            switch result {
            case .success(_):
                XCTFail("Le géocodage a réussi alors que l'adresse était invalide")
            case .failure(let error):

                XCTAssertEqual((error as NSError).domain, "GeocodeError", "Le domaine de l'erreur n'est pas celui attendu")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
