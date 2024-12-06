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
    
        func searchEvents(by keyword: String, completion: @escaping (Result<[EventEntry], Error>) -> Void) {
            var query: Query = Firestore.firestore().collection("eventorias")
                .order(by: "title", descending: true)

            if !keyword.isEmpty {
                query = query.whereField("title", isGreaterThanOrEqualTo: keyword)
                    .whereField("title", isLessThanOrEqualTo: keyword + "\u{f8ff}")
            }

            query.addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let events = documents.compactMap { doc -> EventEntry? in
                    let data = doc.data()
                    return EventEntry(
                        picture: data["picture"] as? String ?? "",
                        title: data["title"] as? String ?? "",
                        dateCreationString: data["dateCreationString"] as? String ?? "",
                        poster: data["poster"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        hour: data["hour"] as? String ?? "",
                        category: data["category"] as? String ?? "",
                        place: Adress(
                            street: data["street"] as? String ?? "",
                            city: data["city"] as? String ?? "",
                            posttalCode: data["posttalCode"] as? String ?? "",
                            country: data["country"] as? String ?? ""
                        )
                    )
                }
                completion(.success(events))
            }
        }

    func getAllProductsSortedByDate(descending:Bool) async throws -> [EventEntry]{
        try  db.collection("eventorias")
            .order(by: "title", descending: descending)
    }
}
