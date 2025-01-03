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
                                .accessibilityLabel("Event Date")
                            
                            DatePicker("", selection: $hours, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.automatic)
                                .foregroundColor(.white)
                                .padding(.leading, 5)
                                .labelsHidden()
                                .accessibilityLabel("Event Time")
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
                    .accessibilityLabel("Select Event Category")
                    
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
                                    .accessibilityLabel("Select Image from Camera")
                            }
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let selectedItem = selectedItem {
                                    do {
                                        if let data = try await selectedItem.loadTransferable(type: Data.self) {
                                            selectedImageData = data
                                            
                                            await addEventViewModel.uploadImageToFirebaseStorage(imageData: data)
                                            
                                            if let imageUrl = addEventViewModel.imageUrl {
                                                self.imageUrl = imageUrl
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
                                    .accessibilityLabel("Select Image from Gallery")
                            }
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let selectedItem = selectedItem {
                                    do {
                                        if let data = try await selectedItem.loadTransferable(type: Data.self) {
                                            selectedImageData = data
                                            
                                            await addEventViewModel.uploadImageToFirebaseStorage(imageData: data)
                                            
                                            if let imageUrl = addEventViewModel.imageUrl {
                                                self.imageUrl = imageUrl
                                            }
                                        }
                                    } catch {
                                        print("Erreur lors de la récupération des données de l'image : \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .accessibilityLabel("Selected Image")
                    }
                    
                    if let errorMessage = locationCoordinate.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .accessibilityLabel("Error Message")
                    }
                    
                    Spacer()
                    
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
                    .accessibilityLabel("Submit Event")
                    .accessibilityHint("Submits the event after validation.")
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.white)
                        Text("Creation of an event")
                            .font(.custom("Inter-SemiBold", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
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
                    .accessibilityLabel(infos)
                    .accessibilityHint("Enter your \(infos.lowercased()) here.")
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
                    .accessibilityLabel(text)
                    .accessibilityHint("Enter your \(text.lowercased()) here.")
            }
            .padding()
        }
    }
}
