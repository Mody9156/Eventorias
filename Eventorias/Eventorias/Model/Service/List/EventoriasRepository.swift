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
        
        do{
            try db
                 .collection("eventorias")
                 .addDocument(from: eventEntry){ error in
                     if let error = error {
                         print("Erreur lors de l'ajout de l'événement : \(error.localizedDescription)")
                     } else {
                         print("Événement ajouté avec succès")
                     }
                 }
            
            print("")
        }catch{
            print("Erreur lors de la conversion de l'événement en dictionnaire : \(error.localizedDescription)")

        }
       
    }
    
    func tryEvenement() {
         db
            .collection("eventorias")
            .order(by: "title", descending: true)
            
    }
    
//    func fetchData(){
//        db
//            .collection("eventorias")
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Erreur lors de la récupération des données : \(error.localizedDescription)")
//                }else {
//                    eventEntry = snapshot?.documents.compactMap{ document in
//                        return document.get("eventoria") as? String
//                    } ?? []
//                }
//            }
//    }
}
