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
    
    func testFetchURLRequest() throws {
        let latitude: Double = 37.3811
        let longitude: Double = -122.3348
        let apiKey = "mockAPIKey"
        
        let request = try googleMapView.fetchURLRequest(latitude, longitude, apiKey)
        
        let expectedURLString = "https://maps.googleapis.com/maps/api/staticmap?center=\(latitude),\(longitude)&zoom=12&size=149x72&maptype=roadmap&key=\(apiKey)"
        
        XCTAssertEqual(request.url?.absoluteString, expectedURLString)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
    
    func testShowMapsWithURLRequest_Success() async {
        let latitude: Double = 37.3811
        let longitude: Double = -122.3348
        let apiKey = "mockAPIKey"
        
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
    
    func testShowMapsWithURLRequest_InvalidData() async {
        let latitude: Double = 0.0
        let longitude: Double = 0.0
        let apiKey = "mockAPIKey"
        
        do {
            _ = try await googleMapView.showMapsWithURLRequest(latitude, longitude, apiKey)
            XCTFail("Expected invalidData error, but no error was thrown.")
        } catch GoogleMapView.AuthenticationError.invalidData {
        } catch {
            XCTFail("Expected invalidData error, but got \(error).")
        }
    }
    
    func testShowMapsWithURLRequest_BadServerResponse() async {
        let latitude: Double = 37.3811
        let longitude: Double = -122.3348
        let apiKey = "mockAPIKey"
        
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
    
    
    func testShowMapsWithURLRequest_EmptyData() async {
        let latitude: Double = 37.3811
        let longitude: Double = -122.3348
        let apiKey = "mockAPIKey"
        
        mockHTTPService.mockData = Data()
        mockHTTPService.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)
        
        do {
            _ = try await googleMapView.showMapsWithURLRequest(latitude, longitude, apiKey)
            XCTFail("Expected invalidData error, but no error was thrown.")
        } catch GoogleMapView.AuthenticationError.invalidData {
        } catch {
            XCTFail("Expected invalidData error, but got \(error).")
        }
    }
    
}
