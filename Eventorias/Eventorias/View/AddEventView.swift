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
    @State private var date : Date = Date()
    @State private var imageURL: URL? = nil
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image : UIImage?
    @State var selectedItems : [PhotosPickerItem] = []
    @State var showAddress : Bool = false
    @State var street : String = ""
    @State var city : String = ""
    @State var postalCode : String = ""
    @State var country : String = ""
    @State var hours : Date = Date()
    @State private var savedFilePath: String?
    @State var category : String = ""
    @StateObject var addEventViewModel : AddEventViewModel
    @Environment(\.dismiss) var dismiss
    @State var address : String = ""
    @StateObject var locationCoordinate : LocationCoordinate
    @State private var latitude : Double = 0.0
    @State private var longitude : Double = 0.0
    @State var picture = UserDefaults.standard.string(forKey: "userPicture")

    private let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var indexCategory = ["Music","Food","Book","Conference","Exhibition","Charity","Film"]
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            ScrollView {
                VStack{
                    
                    CustomTexField(text: $title, infos: "Title", placeholder: "New event")
                    
                    CustomTexField(text: $description, infos: "Description", placeholder: "Tap here entrer your description")
                    
                    HStack {
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.automatic)
                            .foregroundColor(.white)
                            .padding(.leading, 5)
                            .labelsHidden()
                        
                        DatePicker("HH:MM", selection: $hours, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.automatic)
                            .foregroundColor(.white)
                            .padding(.leading, 5)
                            .labelsHidden()
                    }
                    
                    VStack{
                        AddressCollect(text: "Street", textField: $street, placeholder: "Street")
                        AddressCollect(text: "City", textField: $city, placeholder: "City")
                        AddressCollect(text: "PostalCode", textField: $postalCode, placeholder: "PostalCode")
                        AddressCollect(text: "Country", textField: $country, placeholder: "Country")
                    }
                    
                    Picker("Category", selection:$category) {
                        ForEach(indexCategory,id:\.self){ index in
                            Text(index)
                                .tag(index)
                                .foregroundColor(.white)
                        }
                    }
                    
                    
                    HStack(alignment: .center){
                        Button(action:{
                            self.showCamera.toggle()
                        }){
                            ZStack {
                                Rectangle()
                                    .frame(width: 52, height:52)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                                
                                Image("Camera")
                                    .foregroundColor(.black)
                            }
                        }
                        .fullScreenCover(isPresented: self.$showCamera) {
                            accessCameraView(selectedImage: self.$selectedImage)
                                .background(.black)
                        }
                        
                        PhotosPicker(selection:$selectedItems,
                                     matching:.images) {
                            
                            ZStack {
                                Rectangle()
                                    .frame(width: 52, height:52)
                                    .foregroundColor(Color("Button"))
                                    .cornerRadius(16)
                                
                                Image("attach")
                            }
                        }.onChange(of: selectedItems) { newValue in
                            for item in newValue {
                                Task{
                                    if let data = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: data){
                                        savedFilePath = addEventViewModel.saveImageToTemporaryDirectory(image: image, fileName: "\(title).jpg")
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    
                    if let errorMessage = locationCoordinate.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    Text(address)
                    Spacer()
                    
                    Button(action:{
                        
                        if street.isEmpty || city.isEmpty || postalCode.isEmpty || country.isEmpty {
                            self.locationCoordinate.errorMessage = "Tous les champs de l'adresse doivent être remplis."
                        } else {
                            
                            address = "\(street), \(city) \(postalCode), \(country)"
                            locationCoordinate.geocodeAddress(address: address){ result in
                                switch result {
                                case .success(let coord):
                                    latitude = coord.0
                                    longitude = coord.1
                                    print("Coordonnées récupérées : \(coord.0), \(coord.1)")
                                    break
                                case .failure(let error):
                                    print("Erreur lors du géocodage : \(error.localizedDescription)")
                                    break
                                }
                            }
                            
                            
                            guard let selectedImage = selectedImage else {
                                return
                            }
                            guard let savedFilePath = savedFilePath else {
                                return
                            }
                            
                            guard let selected = addEventViewModel.saveImageToTemporaryDirectory(image: selectedImage,fileName: "\(title).jpg") else {
                                return
                            }
                            
                            let fileURLSelected = URL(fileURLWithPath: selected)
                            let fileURLStringSelected = fileURLSelected.absoluteString
                            
                            let stringFromHour = addEventViewModel.formatHourString(hours)
                            let fileURL = URL(fileURLWithPath: savedFilePath)
                            let fileURLString = fileURL.absoluteString
                            
                            addEventViewModel.saveToFirestore(
                                picture: fileURLStringSelected,
                                title: title,
                                dateCreation: date,
                                poster: fileURLString,
                                description: description,
                                hour: stringFromHour,
                                category: category,
                                street: street,
                                city: city,
                                postalCode: postalCode,
                                country: country,
                                latitude: latitude,
                                longitude: longitude)
                            
                        }
                    }){
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
    @Binding var text : String
    var infos : String
    var placeholder : String
    var body: some View {
        ZStack{
            Rectangle()
                .frame(height: 56)
                .foregroundColor(Color("BackgroundDocument"))
                .cornerRadius(5)
            
            VStack(alignment: .leading) {
                Text(infos)
                    .font(.custom("Inter", size: 12))
                    .fontWeight(.regular)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .textCase(.none)
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
        
        // Vérifie si la caméra est disponible avant de l'utiliser
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Si la caméra n'est pas disponible, utilise la bibliothèque photo
            imagePicker.sourceType = .photoLibrary
            // On peut aussi montrer une alerte ici dans le Coordinator
            context.coordinator.showCameraUnavailableAlert()
        } else {
            // Si la caméra est disponible, utilise la caméra
            imagePicker.sourceType = .camera
        }
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> CameraManager {
        return CameraManager(picker: self)
    }
}

struct AddressCollect: View {
    var text : String
    @Binding var textField : String
    var placeholder : String
    
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
                    .multilineTextAlignment(.leading)
                    .textCase(.none)
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
        AddEventView(
            addEventViewModel: AddEventViewModel(),
            locationCoordinate: LocationCoordinate()
            )
        
    }
}
