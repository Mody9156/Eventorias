//
//  FirestoreCollectionProtocolToList.swift
//  Eventorias
//
//  Created by KEITA on 27/12/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirestoreQueryProtocol {
   func order(by field: String, descending: Bool)

}

protocol FirestoreCollectionProtocols: FirestoreQueryProtocol {}

//CollectionReference est une class de Firestore
extension CollectionReference: FirestoreCollectionProtocols {
   
    func order(by field: String, descending: Bool){
            return self.order(by: field, descending: descending)
        }
}



