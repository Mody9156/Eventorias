//
//  ProtocolsAPiMapsStatic.swift
//  Eventorias
//
//  Created by KEITA on 13/12/2024.
//

import Foundation
 
protocol HTTPService {
    func fetchRequest(_ request:URLRequest) async throws -> (Data,URLResponse)
}
