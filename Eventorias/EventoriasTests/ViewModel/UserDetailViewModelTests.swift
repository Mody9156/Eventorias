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
        
        // Crée un mock de GoogleMapView
        mockGoogleMapView = MockGoogleMapView()
        
        // Crée un mock de ListViewModel avec des événements fictifs
        mockListViewModel = MockListViewModel(eventEntry: [EventEntry(name: "Test Event")])
        
        // Initialise le ViewModel avec les mocks
        viewModel = UserDetailViewModel(eventEntry: mockListViewModel.eventEntry, listViewModel: mockListViewModel, googleMapView: mockGoogleMapView)
    }
    
    override func tearDown() {
        viewModel = nil
        mockGoogleMapView = nil
        mockListViewModel = nil
        super.tearDown()
    }

    // Test de la méthode loadAPIKey()
    func testLoadAPIKeySuccess() {
        // Créer un fichier Config.plist fictif
        let apiKey = "mockAPIKey"
        
        // Simuler l'existence d'un fichier Config.plist
        let mockBundle = BundleMock(apiKey: apiKey)
        viewModel.loadAPIKey(using: mockBundle)
        
        XCTAssertEqual(try! viewModel.loadAPIKey(), apiKey)
    }

    func testLoadAPIKeyFailure() {
        // Simule une erreur si la clé API est manquante dans le fichier
        let mockBundle = BundleMock(apiKey: nil)
        XCTAssertThrowsError(try viewModel.loadAPIKey(using: mockBundle)) { error in
            XCTAssertEqual(error as? UserDetailViewModel.Failure, .missingAPIKey)
        }
    }
    
    // Test de la méthode showMapsStatic()
    func testShowMapsStaticSuccess() async {
        // Simuler une réponse réussie de GoogleMapView
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
        // Simuler une erreur de la méthode showMapsWithURLRequest
        let latitude: Double = 37.3811
        let longitude: Double = -122.3348
        
        // Simule une erreur d'API
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
}

// Mock pour la méthode loadAPIKey
class BundleMock: Bundle {
    var mockAPIKey: String?
    
    init(apiKey: String?) {
        self.mockAPIKey = apiKey
    }
    
    override func path(forResource name: String?, ofType ext: String?) -> String? {
        return mockAPIKey != nil ? "mockConfigPlist" : nil
    }
    
    override func dictionaryForResource(_ name: String?, ofType ext: String?) -> [String: Any]? {
        return mockAPIKey != nil ? ["API_KEY": mockAPIKey!] : nil
    }
}

// Mock pour GoogleMapView
class MockGoogleMapView: GoogleMapView {
    var mockData: Data?
    var mockResponse: HTTPURLResponse?
    var mockError: Error?
    
    override func showMapsWithURLRequest(_ latitude: Double, _ longitude: Double, _ key: String) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockData ?? Data()
    }
}

// Mock pour ListViewModel
class MockListViewModel {
    var eventEntry: [EventEntry]
    
    init(eventEntry: [EventEntry]) {
        self.eventEntry = eventEntry
    }
}
