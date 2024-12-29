//
//  UserDetailViewModelTests.swift
//  EventoriasTests
//
//  Created by KEITA on 28/12/2024.
//

import XCTest
@testable import Eventorias

final class UserDetailViewModelTests: XCTestCase {

    var viewModel: UserDetailViewModel!
    var mockGoogleMapView: MockGoogleMapView!
    var mockListViewModel: MockListViewModel!
    
    override func setUp() {
        super.setUp()
        
        mockGoogleMapView = MockGoogleMapView()
        
        mockListViewModel = MockListViewModel(eventEntry: [ EventEntry(
                        picture: "https://example.com/event-picture.jpg",
                        title: "Annual Tech Conference",
                        dateCreation: Date(),
                        poster: "John Doe",
                        description: "An exciting tech conference showcasing the latest innovations in AI, blockchain, and IoT.",
                        hour: "10:00",
                        category: "Technology",
                        place: Address(street: "123 Innovation Drive", city: "Techville", postalCode: "94016", country: "USA" ,localisation: GeoPoint(latitude: 37.3811, longitude: -122.3348))
                    )])
        
        viewModel = UserDetailViewModel(eventEntry: mockListViewModel.eventEntry, listViewModel: ListViewModel(), googleMapView: mockGoogleMapView)
    }
    
    override func tearDown() {
        viewModel = nil
        mockGoogleMapView = nil
        mockListViewModel = nil
        super.tearDown()
    }

    func testLoadAPINotNil() throws {
       let key =  try viewModel.loadAPIKey()
        
        XCTAssertNotNil(key)
    }

    func testShowMapsStaticSuccess() async {

        let latitude: Double = 37.3811
        let longitude: Double = -122.3348
        let apiKey = "mockAPIKey"
        
        // Simule une réponse de la méthode showMapsWithURLRequest
        mockGoogleMapView.mockData = Data([0x01, 0x02, 0x03])
        mockGoogleMapView.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            let data = try await viewModel.showMapsStatic(Latitude: latitude, Longitude: longitude)
            XCTAssertEqual(data, mockGoogleMapView.mockData)
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func testShowMapsStaticFailure() async {

        let latitude: Double = 37.3811
        let longitude: Double = -122.3348
        
        mockGoogleMapView.mockError = NSError(domain: "GoogleMap", code: 500, userInfo: nil)
        
        do {
            _ = try await viewModel.showMapsStatic(Latitude: latitude, Longitude: longitude)
            XCTFail("Expected invalidMaps error, but got no error.")
        } catch let error as UserDetailViewModel.Failure {
            XCTAssertEqual(error, .invalidMaps)
        } catch {
            XCTFail("Expected invalidMaps error, but got \(error).")
        }
    }
    func testFormatHourString() {

        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "HH:mm"
           let testDate = dateFormatter.date(from: "14:30")!
           
           let formattedString = viewModel.formatHourString(testDate)
           
           XCTAssertNotNil(formattedString)
       }
}


