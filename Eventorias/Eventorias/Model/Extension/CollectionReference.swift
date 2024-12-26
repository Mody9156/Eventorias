//
//  CollectionReference.swift
//  Eventorias
//
//  Created by KEITA on 26/12/2024.
//

import Foundation
import Firebase
extension CollectionReference : FirestoreCollectionProtocol {
    func addDocument(data: [String: Any], completion: @escaping (Error?) -> Void){
        self.addDocument(data: data) { error in
            completion(error)
        }
    }

}
