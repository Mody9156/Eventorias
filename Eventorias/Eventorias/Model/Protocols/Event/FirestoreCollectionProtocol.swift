//
//  FirestoreCollectionProtocol.swift
//  Eventorias
//
//  Created by KEITA on 26/12/2024.
//

import Foundation

protocol FirestoreCollectionProtocol {
    func addDocument(data: [String: Any], completion: @escaping (Error?) -> Void)

}
