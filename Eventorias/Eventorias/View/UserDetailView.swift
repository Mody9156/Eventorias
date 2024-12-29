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
                                    Label("\(eventEntry.hour)",image:"event")
                                        .foregroundColor(.white)
                                        .frame(width: 141, height: 24)
                                    
                                    
                                    Label("\(userDetailViewModel.formatHourString(eventEntry.hourCreation))",image: "Time")
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

struct MyPreviewProvider_PreviewDetails: PreviewProvider {
    static var previews: some View {
        UserDetailView(eventEntry: EventEntry(picture: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/01/Kyrie_Irving_-_51831772061_01_%28cropped%29.jpg/1024px-Kyrie_Irving_-_51831772061_01_%28cropped%29.jpg", title: "NBA", dateCreation: Date.now, poster: "https://img.freepik.com/photos-gratuite/vaisseau-spatial-orbite-autour-planete-dans-superbe-decor-spatial-genere-par-ia_188544-15610.jpg?t=st=1735041951~exp=1735045551~hmac=9a2fa593903e1ecc1fb77937beca379c4f593ad080b7107e495c9cbb4ec72915&w=1800", description: "Une image est une représentation visuelle, voire mentale, de quelque chose (objet, être vivant ou concept).Elle peut être naturelle (ombre, reflet) ou artificielle (sculpture, peinture, photographie), visuelle ou non, tangible ou conceptuelle (métaphore), elle peut entretenir un rapport de ressemblance directe avec son modèle ou au contraire y être liée par un rapport plus symbolique.Pour la sémiologie ou sémiotique, qui a développé tout un secteur de sémiotique visuelle, l'image est conçue comme produite par un langage spécifique.", hour: "12:33", category: "Music", place: Address(street: "112 Av. de la République", city: "Montgeron", postalCode: "91230", country: "FRANCE", localisation: GeoPoint(latitude: 48.862725, longitude: 2.287592))), userDetailViewModel: UserDetailViewModel(eventEntry: [EventEntry(picture: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/01/Kyrie_Irving_-_51831772061_01_%28cropped%29.jpg/1024px-Kyrie_Irving_-_51831772061_01_%28cropped%29.jpg", title: "NBA", dateCreation: Date.now, poster: "https://img.freepik.com/photos-gratuite/vaisseau-spatial-orbite-autour-planete-dans-superbe-decor-spatial-genere-par-ia_188544-15610.jpg?t=st=1735041951~exp=1735045551~hmac=9a2fa593903e1ecc1fb77937beca379c4f593ad080b7107e495c9cbb4ec72915&w=1800", description: "Une image est une représentation visuelle, voire mentale, de quelque chose (objet, être vivant ou concept).Elle peut être naturelle (ombre, reflet) ou artificielle (sculpture, peinture, photographie), visuelle ou non, tangible ou conceptuelle (métaphore), elle peut entretenir un rapport de ressemblance directe avec son modèle ou au contraire y être liée par un rapport plus symbolique.Pour la sémiologie ou sémiotique, qui a développé tout un secteur de sémiotique visuelle, l'image est conçue comme produite par un langage spécifique.", hour: "12:33", category: "Music", place: Address(street: "112 Av. de la République", city: "Montgeron", postalCode: "91230", country: "FRANCE", localisation: GeoPoint(latitude: 48.862725, longitude: 2.287592)))], listViewModel: ListViewModel(), googleMapView: GoogleMapView()), locationCoordinate: LocationCoordinate())
    }
}
