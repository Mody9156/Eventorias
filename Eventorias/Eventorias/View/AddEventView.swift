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
    @Environment(\.dismiss) var dismiss
    @StateObject var addEventViewModel : AddEventViewModel
    private let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    @State private var imageURL: URL? = nil
    @State var resultPicture : String = ""
    
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image : UIImage?
    @State var selectedItems : [PhotosPickerItem] = []
    @State private var showAddress : Bool = false
    @State private var street : String = ""
    @State private var city : String = ""
    @State private var postalCode : String = ""
    @State private var country : String = ""
    @State private var hours : Date = Date()
    
    @State private var savedFilePath: String?
    var indexCategory = ["Music","Food","Book","Conference","Exhibition","Charity","Film"]
    @State private var category : String = ""
   
    
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
                
                VStack {
                    AddressCollect(Text: <#String#>, TextField: <#String#>)
                    
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(height: 56)
                                .foregroundColor(Color("BackgroundDocument"))
                                .cornerRadius(5)
                            HStack {
                                Text("City: ")
                                TextField("", text: $city)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        ZStack {
                            Rectangle()
                                .frame(height: 56)
                                .foregroundColor(Color("BackgroundDocument"))
                                .cornerRadius(5)
                            HStack {
                                Text("PostalCode: ")
                                TextField("", text: $postalCode)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    ZStack {
                        Rectangle()
                            .frame(height: 56)
                            .foregroundColor(Color("BackgroundDocument"))
                            .cornerRadius(5)
                        HStack {
                            Text("country: ")
                            TextField("", text: $country)
                                .foregroundColor(.white)
                        }
                    }
                    
                }
                .padding()
             
                
                Picker("Category", selection:$category) {
                    ForEach(indexCategory,id:\.self){ index in
                        Text(index)
                            .tag(index)
                            .foregroundColor(.white)
                    }
                }
                .pickerStyle(.wheel)
                
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
                
                if let savedFilePath = savedFilePath {
                    Text(savedFilePath)
                        .foregroundColor(.white)
                }
                //                if let selectedImage = savedFilePath, let image =  UIImage(contentsOfFile: selectedImage) {
                //                    Image(uiImage: image)
                //                }
                
                Spacer()
                
                Button(action:{
                   var localisation = "\(street) + \(city) \(postalCode) \(country)"
                    
                    addEventViewModel.geocodeAddress(address: localisation)
                    //                    if let selectedImage = savedFilePath{
                    //                    let dummyImage = UIImage(contentsOfFile: selectedImage)! // Remplacez par votre UIImage
                    //                    if let path = saveImageToTemporaryDirectory(image: dummyImage, fileName: "\(title)Post.jpg") {
                    //                        savedFilePath = path
                    //                        imageURL = URL(fileURLWithPath: path) // Convertir le chemin en URL
                    //                    }
                    //                }
                    
                    if let selectedImage = selectedImage ,
                       let savedFilePath = savedFilePath,
                       let selected = addEventViewModel.saveImageToTemporaryDirectory(image: selectedImage,fileName: "\(title).jpg"),
                       let latitude = addEventViewModel.coordinates?.latitude, let longitude = addEventViewModel.coordinates?.longitude{
                        
                        resultPicture = selected
                        var stringFromHour = String(Date.stringFromHour(hours))
                        
                        addEventViewModel.saveToFirestore(picture: selected, title: title,
                                                          dateCreation: date, poster: savedFilePath,
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
        }
       
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(addEventViewModel: AddEventViewModel(coordinates: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)))
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
                    .opacity(0.5)
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


struct AddressCollect: View {
    var Text : String
    var TextField : String
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .frame(height: 56)
                    .foregroundColor(Color("BackgroundDocument"))
                    .cornerRadius(5)
                HStack {
                    Text("Street: ")
                    TextField("", text: $street)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
