//
//  DataList.swift
//  Eventorias
//
//  Created by KEITA on 27/12/2024.
//

import Foundation

import Foundation

protocol DataList {
    associatedtype T: Decodable
    func getDocuments() async throws -> [T]
    func addDocument(data: [String: Any]) async throws
    func updateDocument(documentID: String, data: [String: Any]) async throws
    func deleteDocument(documentID: String) async throws
}
