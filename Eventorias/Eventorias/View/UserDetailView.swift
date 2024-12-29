//
//  UserDetailView.swift
//  Eventorias
//
//  Created by KEITA on 01/12/2024.
//

import SwiftUI

struct UserDetailView: View {
    let eventEntry: EventEntry
    @StateObject var userDetailViewModel: UserDetailViewModel
    @StateObject var locationCoordinate: LocationCoordinate
    @State var maps: UIImage?
    @State var address: String = ""
    @State var coordString = ""
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        VStack{
                            
                            AsyncImage(url: URL(string: eventEntry.poster)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 358, height: 364)
                                    .cornerRadius(12)
                            } placeholder: {
                                ProgressView()
                            }
//                        format: .dateTime.day().month().year())
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Label("\(userDetailViewModel.formatDateString(eventEntry.dateCreation))",image:"event")
                                        .foregroundColor(.white)
                                        .frame(width: 141, height: 24)
                                    
                                    
                                    Label("\(eventEntry.hour)",image: "Time")
                                        .foregroundColor(.white)
                                        .frame(width: 109, height:24)
                                    
                                }
                                .padding()
                                Spacer()
                             
                                .padding(.trailing,40)
                                if let picture = eventEntry.picture{
                                    Image(picture)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(50)
                                        .padding(.trailing,40)
                                }

                            }
                            
                            ScrollView {
                                Text(eventEntry.description)
                                    .font(.custom("Inter", size: 14))
                                    .fontWeight(.regular)
                                    .lineSpacing(20 - 14)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(eventEntry.place.street)
                                        .foregroundColor(.white)
                                        .font(.custom("Inter-Medium", size: 16))
                                        .fontWeight(.medium)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                        .truncationMode(.tail)

                                    HStack {
                                        Text("\(eventEntry.place.city),")
                                            .foregroundColor(.white)
                                            .font(.custom("Inter-Medium", size: 16))
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                        Text("\(eventEntry.place.postalCode),")
                                            .foregroundColor(.white)
                                            .font(.custom("Inter-Medium", size: 16))
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                    }
                                    
                                    HStack{
                                        Text(eventEntry.place.country)
                                            .foregroundColor(.white)
                                            .font(.custom("Inter-Medium", size: 16))
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                    }
                                }
                          

                                
                                Spacer()
                                
                                if let picture = maps {
                                    Image(uiImage: picture)
                                        .cornerRadius(20)
                                        .padding()
                                }
                                
                                
                            }.onAppear {
                                fetchMapData()
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
    private func fetchMapData(){
        let address = "\(eventEntry.place.street), \(eventEntry.place.postalCode) \(eventEntry.place.city), \(eventEntry.place.country)"
        locationCoordinate.geocodeAddress(address: address) { result in
               switch result {
               case .success(let coords):
                   print("Coordonnées récupérées : \(coords.0), \(coords.1)")
                   Task {
                       let imageData = try await userDetailViewModel.showMapsStatic(Latitude: coords.0, Longitude: coords.1)
                       if let image = UIImage(data: imageData) {
                           maps = image
                       }
                   }
               case .failure(let error):
                   print("Erreur lors du géocodage : \(error.localizedDescription)")
               }
           }
    }
}
