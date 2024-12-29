//
//  EventManagerProtocol.swift
//  Eventorias
//
//  Created by KEITA on 18/12/2024.
//

import Foundation

protocol EventManagerProtocol {
    func saveToFirestore(_ event: EventEntry,completion:@escaping(Bool,Error?)-> Void )
    func uploadImageToFirebaseStorage(imageData: Data, completion: @escaping (String?, Error?) -> Void) async
    func saveImageUrlToFirestore(url: String, completion: @escaping (Bool, Error?) -> Void)
}

//protocol CollectionReferenceProtocol {
//    func addDocumentWithData(data: [String: Any], completion: @escaping (Error?) -> Void)
//
//}
