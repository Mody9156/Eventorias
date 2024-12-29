import XCTest
@testable import Eventorias

class ListViewModelTests: XCTestCase {
  
    var listViewModel: ListViewModel!
    var mockEventListRepresentable: MockEventListRepresentable!
    
    override func setUp() {
        super.setUp()
        mockEventListRepresentable = MockEventListRepresentable()
        listViewModel = ListViewModel(eventListRepresentable: mockEventListRepresentable)
    }
    
    override func tearDown() {
        listViewModel = nil
        mockEventListRepresentable = nil
        super.tearDown()
    }
    
    func testGetAllProductsSuccess() async {
        let expectation = self.expectation(description: "getAllProducts")

        do {

            try await listViewModel.getAllProducts()
            XCTAssertFalse(listViewModel.isError)
            XCTAssertEqual(listViewModel.eventEntry.count, 1)
            XCTAssertEqual(listViewModel.eventEntry.first?.title, "Annual Tech Conference")
            expectation.fulfill() // Réussite de l'attente
        } catch {
            XCTFail("Erreur lors de la récupération des événements: \(error.localizedDescription)")
        }
        
        await waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetAllProductsFailure() async {
        mockEventListRepresentable.shouldReturnError = true
        
        let expectation = self.expectation(description: "getAllProductsFailure")
        
        do {
            try await listViewModel.getAllProducts()
            XCTFail("Une erreur aurait dû être lancée")
        } catch {
            XCTAssertTrue(listViewModel.isError)
            expectation.fulfill()
        }
        
       
        await waitForExpectations(timeout: 5, handler: nil)
    }


    
    func testFilterSelectedNoFilter() async {

        let expectation = self.expectation(description: "filterSelectedNoFilter")
        
        do {
            try await listViewModel.filterSelected(option: .noFilter)
            XCTAssertEqual(listViewModel.eventEntry.count, 1)
            expectation.fulfill()
        } catch {
            XCTFail("Erreur lors de l'application du filtre sans filtre : \(error.localizedDescription)")
        }
        
        await waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFilterSelectedCategory() async {
        let expectation = self.expectation(description: "filterSelectedCategory")
        
        do {
            try await listViewModel.filterSelected(option: .category)
            XCTAssertEqual(listViewModel.eventEntry.count, 1) // Un événement filtré par catégorie "Music"
            XCTAssertEqual(listViewModel.eventEntry.first?.category, "Music") // Vérifier la catégorie
            expectation.fulfill() // Réussite de l'attente
        } catch {
            XCTFail("Erreur lors de l'application du filtre par catégorie : \(error.localizedDescription)")
        }
        
        await waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFilterSelectedDate() async {
        let expectation = self.expectation(description: "filterSelectedDate")
        
        do {
            try await listViewModel.filterSelected(option: .date)
            XCTAssertEqual(listViewModel.eventEntry.count, 1) 
            XCTAssertEqual(listViewModel.eventEntry.first?.title, "Sports Championship")
            expectation.fulfill() // Réussite de l'attente
        } catch {
            XCTFail("Erreur lors de l'application du filtre par date : \(error.localizedDescription)")
        }
        
        await waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFilterTitle() {
        let searchText = "Tech Conference"
        let filteredEvents = listViewModel.filterTitle(searchText)
        XCTAssertEqual(filteredEvents.count, 0)
        
        let emptySearchText = ""
        let filteredEventsEmpty = listViewModel.filterTitle(emptySearchText)
        XCTAssertEqual(filteredEventsEmpty.count, 0)
    }
}
