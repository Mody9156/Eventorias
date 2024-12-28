//
//  MockHTTPService.swift
//  EventoriasTests
//
//  Created by KEITA on 28/12/2024.
//

import XCTest
@testable import Eventorias
final class MockHTTPService: HTTPService {

    var mockData: Data?
       var mockResponse: URLResponse?
       var mockError: Error?
       
       func fetchRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
           if let error = mockError {
               throw error
           }
           
           guard let data = mockData else {
               throw URLError(.badServerResponse)
           }
           
           return (data, mockResponse ?? HTTPURLResponse())
       }

}
