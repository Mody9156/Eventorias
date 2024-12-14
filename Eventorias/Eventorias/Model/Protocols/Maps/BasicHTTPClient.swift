//
//  BasicHTTPClient.swift
//  Eventorias
//
//  Created by KEITA on 13/12/2024.
//

import Foundation

class BasicHTTPClient : HTTPService {
    
    private let session : URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    enum Failure: Swift.Error {
            case requestInvalid
        }
    
    func fetchRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        let (data,response) = try await session.data(for: request)
        
        guard let httpResponse =  response as? HTTPURLResponse,httpResponse.statusCode == 200  else {
            throw Failure.requestInvalid
        }
        return (data,response)
    }
    
 
    
}
