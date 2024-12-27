//
//  DataList.swift
//  Eventorias
//
//  Created by KEITA on 27/12/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirestoreServiceList {
    func collection(_ path: String) -> FirestoreQuery
}

protocol FirestoreQuery {
    associatedtype T: Decodable
    func getDocuments() async throws -> [T]
    func order(by field: String, descending: Bool) -> Self
    func whereField(_ field: String, isEqualTo value: Any) -> Self
}
