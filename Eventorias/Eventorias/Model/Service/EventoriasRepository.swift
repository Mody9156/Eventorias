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
    
    func subscribe(){
        let query = Firestore.firestore()
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
       try Firestore
            .firestore()
            .collection("eventorias")
            .addDocument(from: eventEntry)
    }
}
