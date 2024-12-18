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

struct AddEventView: View {
    @State var title = ""
    @State var description = ""
    @State private var date : Date = Date()
    @State var address : String = ""
    @Environment(\.dismiss) var dismiss
    @StateObject var addEventViewModel : AddEventViewModel
    private let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    @State var resultPicture : String = ""
    @State private var coordinates : CLLocationCoordinate2D?
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image : UIImage?
    @State var selectedItems : [PhotosPickerItem] = []
    @State private var errorMessage: String?
    @State private var showAddress : Bool = false
    @State private var street : String = ""
    @State private var city : String = ""
    @State private var postalCode : String = ""
    @State private var country : String = ""
    @State private var hours : Date = Date()
    @State private var savedFilePath: String?
    
    func saveImageToTemporaryDirectory(image:UIImage, fileName:String) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else {return nil }
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do{
            try data.write(to: fileURL)
            return fileURL.path
            
        }catch{
            print("Erreur \(error)")
            return nil
        }
    }
    
    func geocodeAdress(address:String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address){ placemarks, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.coordinates = nil
            }else if let placemark = placemarks?.first, let location = placemark.location {
                self.coordinates = location.coordinate
                self.errorMessage = nil
            }else{
                self.errorMessage = "Adresse introuvable"
                self.coordinates = nil
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack{
                CustomTexField(text: $title, size: false, placeholder: "New event")
                
                CustomTexField(text: $description,size:false, placeholder: "Tap here entrer your description")
                
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
                
                Button(action:{
                    showAddress.toggle()
                }){
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(height: 56)
                            .foregroundColor(Color("BackgroundDocument"))
                            .cornerRadius(5)
                        
                        Text("Entre full adress")
                    }
                    .padding()
                }.sheet(isPresented: $showAddress) {
                    AddressInputView(street: $street, city: $city, postalCode: $postalCode, country: $country, address: $address)
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
                                    savedFilePath = saveImageToTemporaryDirectory(image: image, fileName: "\(title).jpg")
                                }
                            }
                        }
                    }
                }
                .padding()
                if let latitude = coordinates?.latitude {
                    Text("latitude \(latitude)")
                }
                if let latitude = coordinates?.longitude {
                    Text("Longitude \(latitude)")
                }
                if let item = savedFilePath {
                    Text(item)
                }
                Spacer()
                
                Button(action:{
                    geocodeAdress(address: address)
                    if let selectedImage = selectedImage {
                        if let selected = saveImageToTemporaryDirectory(image: selectedImage, fileName: "\(title).jpg") {
                            resultPicture = selected
                        }
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
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(addEventViewModel: AddEventViewModel())
    }
}

struct CustomTexField: View {
    @Binding var text : String
    var size : Bool
    var placeholder : String
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 56)
                .foregroundColor(Color("BackgroundDocument"))
                .cornerRadius(5)
            if text.isEmpty{
                Text(placeholder)
                    .foregroundColor(.white)
                    .padding()
            }
            
            TextField("", text: $text)
                .foregroundColor(.white)
        }
        .padding()
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

