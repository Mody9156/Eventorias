//
//  EventoriasRepository.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public class EventoriasRepository : ObservableObject, EventListRepresentable {
    
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
    
    func tryEvenement() {
         db
            .collection("eventorias")
            .order(by: "title",descending: true)
            .getDocuments(completion: { snapshot, error in
                if let error = error {
                    print("Erreur : \(error)")
                    return
                }
                
                self.eventEntry = snapshot?.documents.compactMap { document -> EventEntry? in
                                   let data = document.data()
                                   let title = data["title"] as? String ?? ""
                                   let picture = data["picture"] as? String ?? ""
                                   let poster = data["poster"] as? String ?? ""
                                   let dateCreationString = data["dateCreationString"] as? String ?? ""
                    
                    let event = EventEntry(picture: picture, title: title, dateCreationString: dateCreationString, poster: poster)
                                   return event
                               } ?? []
            })
    }
}
