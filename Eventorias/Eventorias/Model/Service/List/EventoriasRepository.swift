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
                                   let description = data["description"] as?String ?? ""
                                   let hour = data["hour"] as?String ?? ""
                                   let category = data["category"] as?String ?? ""
                                   let place = data["place"] as?String ?? ""
                                   let street = data["street"] as?String ?? ""
                                   let posttalCode = data["posttalCode"] as?String ?? ""
                                   let country = data["country"] as?String ?? ""
                                   let city = data["city"] as?String ?? ""
                    
                    
                    let event = EventEntry(picture: "TechConference", title: "Tech conference", dateCreationString: "2024-08-05T12:00:00Z", poster: "TechConferencePoster",description:"Join us for an exclusive Tech Conference showcasing the latest innovations and breakthroughs in technology. This conference will feature a dynamic lineup of keynote speakers, interactive workshops, and cutting-edge product demonstrations, offering a unique opportunity to explore the forefront of technological advancement. Whether you're a seasoned professional, an entrepreneur, or simply curious about the future of tech, you'll have the chance to connect with industry leaders, gain valuable insights, and expand your network. Don’t miss this opportunity to be part of a transformative experience that shapes the future of innovation!",hour:"2024-08-05T02:30:00Z", category: "Conference", place: Adress(street: "300 W San Carlos St", city: "San Jose", posttalCode: "95110", country: "USA"))
                                   return event
                               } ?? []
            })
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
