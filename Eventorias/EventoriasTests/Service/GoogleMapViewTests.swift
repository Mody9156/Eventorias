//
//  GoogleMapViewTests.swift
//  EventoriasTests
//
//  Created by KEITA on 28/12/2024.
//

import XCTest
@testable import Eventorias
final class GoogleMapViewTests: XCTestCase {
    
        var googleMapView: GoogleMapView!
        var mockHTTPService: MockHTTPService!

        override func setUp() {
            super.setUp()
            
            mockHTTPService = MockHTTPService()
            googleMapView = GoogleMapView(httpService: mockHTTPService)
        }
        
        override func tearDown() {
            googleMapView = nil
            mockHTTPService = nil
            super.tearDown()
        }

        // Test pour vérifier que la URL est correcte
        func testFetchURLRequest() {
            let latitude: Double = 37.3811
            let longitude: Double = -122.3348
            let apiKey = "mockAPIKey"
            
            let request = googleMapView.fetchURLRequest(latitude, longitude, apiKey)
            
            // Vérifie que la requête a été bien formée
            let expectedURLString = "https://maps.googleapis.com/maps/api/staticmap?center=\(latitude),\(longitude)&zoom=12&size=149x72&maptype=roadmap&key=\(apiKey)"
            
            XCTAssertEqual(request.url?.absoluteString, expectedURLString)
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        }

        // Test pour vérifier que la méthode showMapsWithURLRequest fonctionne correctement
        func testShowMapsWithURLRequest_Success() async {
            let latitude: Double = 37.3811
            let longitude: Double = -122.3348
            let apiKey = "mockAPIKey"
            
            // Mock les données de la réponse
            mockHTTPService.mockData = Data([0x01, 0x02, 0x03])
            mockHTTPService.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                            statusCode: 200,
                                                            httpVersion: nil,
                                                            headerFields: nil)
            
            do {
                let data = try await googleMapView.showMapsWithURLRequest(latitude, longitude, apiKey)
                XCTAssertEqual(data, mockHTTPService.mockData)
            } catch {
                XCTFail("Expected no error, but got \(error)")
            }
        }

        // Test pour vérifier que showMapsWithURLRequest lance une erreur si les coordonnées sont invalides
        func testShowMapsWithURLRequest_InvalidData() async {
            let latitude: Double = 0.0
            let longitude: Double = 0.0
            let apiKey = "mockAPIKey"
            
            do {
                _ = try await googleMapView.showMapsWithURLRequest(latitude, longitude, apiKey)
                XCTFail("Expected invalidData error, but no error was thrown.")
            } catch GoogleMapView.AuthenticationError.invalidData {
                // Expected error
            } catch {
                XCTFail("Expected invalidData error, but got \(error).")
            }
        }

        // Test pour vérifier que showMapsWithURLRequest lance une erreur si le statut HTTP n'est pas 200
    func testShowMapsWithURLRequest_BadServerResponse() async {
        let latitude: Double = 37.3811
        let longitude: Double = -122.3348
        let apiKey = "mockAPIKey"
        
        // Mock une réponse avec un code de statut 500 (erreur serveur)
        mockHTTPService.mockData = Data([0x01, 0x02, 0x03])
        mockHTTPService.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                        statusCode: 500,
                                                        httpVersion: nil,
                                                        headerFields: nil)
        
        do {
            _ = try await googleMapView.showMapsWithURLRequest(latitude, longitude, apiKey)
            XCTFail("Expected badServerResponse error, but no error was thrown.")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badServerResponse, "Expected badServerResponse error, but got \(error).")
        } catch {
            XCTFail("Expected badServerResponse error, but got \(error).")
        }
    }

        
        // Test pour vérifier que showMapsWithURLRequest lance une erreur si les données sont vides
        func testShowMapsWithURLRequest_EmptyData() async {
            let latitude: Double = 37.3811
            let longitude: Double = -122.3348
            let apiKey = "mockAPIKey"
            
            // Mock une réponse avec des données vides
            mockHTTPService.mockData = Data()
            mockHTTPService.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                            statusCode: 200,
                                                            httpVersion: nil,
                                                            headerFields: nil)
            
            do {
                _ = try await googleMapView.showMapsWithURLRequest(latitude, longitude, apiKey)
                XCTFail("Expected invalidData error, but no error was thrown.")
            } catch GoogleMapView.AuthenticationError.invalidData {
                // Expected error
            } catch {
                XCTFail("Expected invalidData error, but got \(error).")
            }
        }

    func testWhenUrlThrowError(){
        let invalidLatitude: Double = 9999 // Utilise une latitude invalide pour générer un mauvais URL
            let invalidLongitude: Double = 9999
            let apiKey = "mockAPIKey"
            
            let googleMapView = GoogleMapView() // Initialise l'objet pour tester
            
            // Tester si l'erreur levée est celle attendue
            XCTAssertThrowsError(try googleMapView.fetchURLRequest(invalidLatitude, invalidLongitude, apiKey)) { error in
                XCTAssertEqual(error as? GoogleMapView.AuthenticationError, .invalidUrl, "Expected invalidURL error, but got \(error).")
            }
    }
}
