//
//  AddEventView.swift
//  Eventorias
//
//  Created by KEITA on 16/12/2024.
//
import SwiftUI
import PhotosUI
import CoreLocation
import FirebaseStorage
import FirebaseFirestore

struct AddEventView: View {
    @State var title = ""
    @State var description = ""
    @State private var date = Date()
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var address: String = ""
    @State var street: String = ""
    @State var city: String = ""
    @State var postalCode: String = ""
    @State var country: String = ""
    @State var hours = Date()
    @StateObject var addEventViewModel: AddEventViewModel
    @Environment(\.dismiss) var dismiss
    @StateObject var locationCoordinate: LocationCoordinate
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State var picture = UserDefaults.standard.string(forKey: "userPicture")
    @State var file: String = ""
    @State var showFile: Bool = false
    var indexCategory = ["Music", "Food", "Book", "Conference", "Exhibition", "Charity", "Film"]
    @State private var selectedCategory = "Music"
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var imageUrl: String? = nil
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    CustomTexField(text: $title, infos: "Title", placeholder: "New event")
                    CustomTexField(text: $description, infos: "Description", placeholder: "Tap here to enter your description")
                    
                    VStack {
                        HStack {
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .datePickerStyle(.automatic)
                                .foregroundColor(.white)
                                .padding(.leading, 5)
                                .labelsHidden()
                            
                            DatePicker("", selection: $hours, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.automatic)
                                .foregroundColor(.white)
                                .padding(.leading, 5)
                                .labelsHidden()
                        }
                    }
                    
                    VStack {
                        AddressCollect(text: "Street", textField: $street, placeholder: "Street")
                        AddressCollect(text: "City", textField: $city, placeholder: "City")
                        AddressCollect(text: "PostalCode", textField: $postalCode, placeholder: "PostalCode")
                        AddressCollect(text: "Country", textField: $country, placeholder: "Country")
                    }
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(indexCategory, id: \.self) { index in
                            Text(index)
                                .tag(index)
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    //                     Image Selection Button
                    HStack {
                        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 72, height: 72)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                                Image("Camera")
                                    .foregroundColor(.black)
                                    .font(.system(size: 36))
                            }
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let selectedItem = selectedItem {
                                    do {
                                        // Utilisation de loadTransferable pour récupérer les données
                                        if let data = try await selectedItem.loadTransferable(type: Data.self) {
                                            print("Data de l'image : \(data)") // Affiche les données de l'image
                                            
                                            selectedImageData = data
                                            
                                            // Upload de l'image vers Firebase Storage
                                            await addEventViewModel.uploadImageToFirebaseStorage(imageData: data)
                                            
                                            // Vérifier si l'URL de l'image est bien obtenue
                                            if let imageUrl = addEventViewModel.imageUrl {
                                                print("URL de l'image téléchargée : \(imageUrl)")
                                                self.imageUrl = imageUrl
                                            } else {
                                                print("Erreur : L'URL de l'image n'a pas été récupérée.")
                                            }
                                        }
                                    } catch {
                                        print("Erreur lors de la récupération des données de l'image : \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 72, height: 72)
                                    .foregroundColor(Color("Button"))
                                    .cornerRadius(16)
                                Image(systemName: "paperclip")
                                    .foregroundColor(.white)
                                    .font(.system(size: 36))
                            }
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let selectedItem = selectedItem {
                                    do {
                                        // Utilisation de loadTransferable pour récupérer les données
                                        if let data = try await selectedItem.loadTransferable(type: Data.self) {
                                            print("Data de l'image : \(data)") // Affiche les données de l'image
                                            
                                            selectedImageData = data
                                            
                                            // Upload de l'image vers Firebase Storage
                                            await addEventViewModel.uploadImageToFirebaseStorage(imageData: data)
                                            
                                            // Vérifier si l'URL de l'image est bien obtenue
                                            if let imageUrl = addEventViewModel.imageUrl {
                                                print("URL de l'image téléchargée : \(imageUrl)")
                                                self.imageUrl = imageUrl
                                            } else {
                                                print("Erreur : L'URL de l'image n'a pas été récupérée.")
                                            }
                                        }
                                    } catch {
                                        print("Erreur lors de la récupération des données de l'image : \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }
                    
                    // Affichage de l'image sélectionnée
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                    }
                    
                    if let errorMessage = locationCoordinate.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    // Validation du formulaire
                    Button(action: {
                        validateAndSave()
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: 358, height: 52)
                                .foregroundColor(Color("Button"))
                            Text("Validate")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle(Text("Creation of an event"), displayMode: .inline) // Titre personnalisé
        .navigationBarItems(leading: Text("") // Titre avec une police spécifique
            .font(.custom("Inter-SemiBold", size: 20)) // Applique la police Inter Semi Bold
            .fontWeight(.semibold) // Applique fontWeight: 600
            .foregroundColor(.white) // Couleur du texte
            .lineSpacing(24.2 - 20) // Line height
            .tracking(0.02) // Letter spacing
            .padding(.leading, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
        )
        .navigationBarBackButtonHidden(false)
    }
    
    // Validation des champs et enregistrement
    private func validateAndSave() {
        if title.isEmpty || description.isEmpty || street.isEmpty || city.isEmpty || postalCode.isEmpty || country.isEmpty {
            locationCoordinate.errorMessage = "Tous les champs doivent être remplis."
            return
        }
        
        address = "\(street), \(city) \(postalCode), \(country)"
        locationCoordinate.geocodeAddress(address: address) { result in
            switch result {
            case .success(let coord):
                latitude = coord.0
                longitude = coord.1
                
                // Vérification de l'URL de l'image avant de sauvegarder
                guard let imageUrl = imageUrl else {
                    print("Erreur : Impossible de créer une image à partir des données.")
                    return
                }
                
                let formattedHour = addEventViewModel.formatHourString(hours)
                addEventViewModel.saveToFirestore(
                    picture: picture ?? "",
                    title: title,
                    dateCreation: date,
                    poster: imageUrl,
                    description: description,
                    hour: formattedHour,
                    category: selectedCategory,
                    street: street,
                    city: city,
                    postalCode: postalCode,
                    country: country,
                    latitude: latitude,
                    longitude: longitude
                )
            case .failure(let error):
                print("Erreur lors du géocodage : \(error.localizedDescription)")
            }
        }
    }
}


struct CustomTexField: View {
    @Binding var text: String
    var infos: String
    var placeholder: String
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 56)
                .foregroundColor(Color("BackgroundDocument"))
                .cornerRadius(5)
            VStack(alignment: .leading) {
                Text(infos)
                    .font(.custom("Inter", size: 12))
                    .fontWeight(.regular)
                    .lineSpacing(4)
                    .foregroundColor(.gray)
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
}

struct AddressCollect: View {
    var text: String
    @Binding var textField: String
    var placeholder: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 56)
                .foregroundColor(Color("BackgroundDocument"))
                .cornerRadius(5)
            VStack(alignment: .leading) {
                Text(text)
                    .font(.custom("Inter", size: 12))
                    .fontWeight(.regular)
                    .lineSpacing(4)
                    .foregroundColor(.gray)
                TextField(placeholder, text: $textField)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
}
