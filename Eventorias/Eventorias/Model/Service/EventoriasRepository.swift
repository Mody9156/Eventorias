//
//  EventoriasRepository.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public class EventoriasRepository : ObservableObject {
    
    @Published
    var eventEntry = [EventEntry]()
    var db = Firestore.firestore()
    
    func subscribe(){
        let query = db
            .collection("eventorias")
        
        query.addSnapshotListener { [weak self] (querySnapshot,error) in
            guard  let documents = querySnapshot?.documents else{
                print("No Documents")
                return
            }
            
            print("Mappin \(documents.count) documents")
            self?.eventEntry = documents.compactMap { querySnapshot in
                do{
                    return try querySnapshot.data(as:EventEntry.self)
                }catch{
                    print("Error While trying to map document \(querySnapshot.documentID): ")
                    return nil
                }
            }
        }
    }
    
    func addEvenement(_ eventEntry:EventEntry ) throws {
       try db
            .collection("eventorias")
            .addDocument(from: eventEntry)
    }
    
    func trieEvenement(_ eventEntry:EventEntry) throws{
        try db
            .collection("eventorias")
            .order(by: "title")
            .getDocuments(completion: { snapshot, error in
                if let error = error {
                    print("Erreur : \(error)")
                    return
                }
                
                for document in snapshot!.documents {
                    print(document.data())
                }
            })
    }
}
