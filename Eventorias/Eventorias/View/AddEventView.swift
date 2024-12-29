//
//  AddEventView.swift
//  Eventorias
//
//  Created by KEITA on 16/12/2024.
//
import SwiftUI
import PhotosUI
import UIKit
import CoreLocation
import AVFoundation

struct AddEventView: View {
    @State var title = ""
    @State var description = ""
    @State private var date = Date()
    @State private var imageURL: URL? = nil
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var address : String = ""
    @State var street : String = ""
    @State var city : String = ""
    @State var postalCode : String = ""
    @State var country : String = ""
    @State var hours = Date()
    @StateObject var addEventViewModel : AddEventViewModel
    @Environment(\.dismiss) var dismiss
    @StateObject var locationCoordinate : LocationCoordinate
    @State private var latitude : Double = 0.0
    @State private var longitude : Double = 0.0
    @State var picture = UserDefaults.standard.string(forKey: "userPicture")
    @State var file : String = ""
    @State var showFile : Bool = false
    var indexCategory = ["Music","Food","Book","Conference","Exhibition","Charity","Film"]
    @State private var selectedCategory = "Music"
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            ScrollView {
                VStack{
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
                    
                    HStack(alignment: .center){
                        Button(action: {
                            self.showCamera.toggle()
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 72, height: 72)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                                Image(systemName: "camera")
                                    .foregroundColor(.black)
                                    .font(.system(size: 36))
                            }
                        }
                        .fullScreenCover(isPresented: $showCamera) {
                            accessCameraView(selectedImage: $selectedImage)
                                .background(.black)
                        }
                        
                        Button(action: {
                            self.showFile.toggle()
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 72, height: 72)
                                    .foregroundColor(Color("Button"))
                                    .cornerRadius(16)
                                Image(systemName: "paperclip")
                                    .foregroundColor(.black)
                                    .font(.system(size: 36))
                            }
                        }
                        .fullScreenCover(isPresented: $showFile) {
                            accessFilesView(selectedImage: $selectedImage)
                                .background(.black)
                        }
                    }
                    
                    if let errorMessage = locationCoordinate.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Validation des champs
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
                                print("Coordonnées récupérées : \(coord.0), \(coord.1)")
                                
                                // Vérifiez si une image a été sélectionnée
                                guard let selectedImage = selectedImage else {
                                    print("Aucune image sélectionnée.")
                                    return
                                }
                                guard let picture = picture else {
                                    return
                                }
                                let sanitizedFileName = addEventViewModel.sanitizeFileName("\(title).jpeg")
                                guard let filePath = addEventViewModel.saveImageToDocumentsDirectory(image: selectedImage, fileName: sanitizedFileName) else {
                                    return
                                }
                                
                                addEventViewModel.saveToFirestore(
                                    picture: picture,
                                    title: title,
                                    dateCreation: date,
                                    poster: filePath,
                                    description: description,
                                    hour:addEventViewModel.formatHourString(hours),
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

struct accessCameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> CameraManager {
        return CameraManager(parent: self)
    }
}

struct accessFilesView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> CameraManager {
        return CameraManager(file: self)
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

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(addEventViewModel: AddEventViewModel(), locationCoordinate: LocationCoordinate())
    }
}
