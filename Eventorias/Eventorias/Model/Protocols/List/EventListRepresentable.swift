//
//  EventListRepresentable.swift
//  Eventorias
//
//  Created by KEITA on 03/12/2024.
//

import Foundation

protocol EventListRepresentable{
    func getAllProducts() async throws -> [EventEntry]
    func getAllProductsSortedByDate() async throws -> [EventEntry]
    func getAllProductsSortedByCategory() async throws -> [EventEntry]
}
