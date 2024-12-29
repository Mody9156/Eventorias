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
                        VStack {
                            // Image de l'événement
                            AsyncImage(url: URL(string: eventEntry.poster)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 358, height: 364)
                                    .cornerRadius(12)
                                    .accessibilityLabel("Poster of \(eventEntry.title)") // Ajout de l'accessibilité
                            } placeholder: {
                                ProgressView()
                            }
                            
                            // Labels avec date et heure
                            HStack {
                                VStack(alignment: .leading) {
                                    Label("\(userDetailViewModel.formatDateString(eventEntry.dateCreation))", image: "event")
                                        .foregroundColor(.white)
                                        .frame(width: 141, height: 24)
                                        .accessibilityLabel("Event creation date: \(userDetailViewModel.formatDateString(eventEntry.dateCreation))") // Label avec date
                                    
                                    Label("\(eventEntry.hour)", image: "Time")
                                        .foregroundColor(.white)
                                        .frame(width: 109, height:24)
                                        .accessibilityLabel("Event time: \(eventEntry.hour)") // Label avec heure
                                }
                                .padding()
                                Spacer()
                                    .padding(.trailing, 40)
                                
                                // Image de l'organisateur de l'événement (si présente)
                                if let picture = eventEntry.picture {
                                    Image(picture)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(50)
                                        .padding(.trailing, 40)
                                        .accessibilityLabel("Organizer picture") // Label pour l'image
                                }
                            }
                            
                            // Description de l'événement
                            ScrollView {
                                Text(eventEntry.description)
                                    .font(.custom("Inter", size: 14))
                                    .fontWeight(.regular)
                                    .lineSpacing(20 - 14)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.white)
                                    .padding()
                                    .accessibilityLabel("Event description: \(eventEntry.description)") // Label pour la description
                            }
                        }
                        
                        // Adresse de l'événement
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
                                        .accessibilityLabel("Street: \(eventEntry.place.street)") // Label pour la rue
                                    
                                    HStack {
                                        Text("\(eventEntry.place.city),")
                                            .foregroundColor(.white)
                                            .font(.custom("Inter-Medium", size: 16))
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                            .accessibilityLabel("City: \(eventEntry.place.city)") // Label pour la ville
                                        Text("\(eventEntry.place.postalCode),")
                                            .foregroundColor(.white)
                                            .font(.custom("Inter-Medium", size: 16))
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                            .accessibilityLabel("Postal code: \(eventEntry.place.postalCode)") // Label pour le code postal
                                    }
                                    
                                    HStack {
                                        Text(eventEntry.place.country)
                                            .foregroundColor(.white)
                                            .font(.custom("Inter-Medium", size: 16))
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                            .accessibilityLabel("Country: \(eventEntry.place.country)") // Label pour le pays
                                    }
                                }
                                
                                Spacer()
                                
                                // Affichage de la carte si disponible
                                if let picture = maps {
                                    Image(uiImage: picture)
                                        .cornerRadius(20)
                                        .padding()
                                        .accessibilityLabel("Map showing event location") // Label pour la carte
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
        .navigationBarTitle(Text(eventEntry.title), displayMode: .inline)
        .navigationBarItems(leading: Text("")
            .font(.custom("Inter-SemiBold", size: 20))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .lineSpacing(24.2 - 20)
            .tracking(0.02)
            .padding(.leading, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityLabel("Event title: \(eventEntry.title)") // Label pour le titre de la barre de navigation
        )
        .navigationBarBackButtonHidden(false)
    }
    
    private func fetchMapData() {
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
