//
//  AddEventView.swift
//  Eventorias
//
//  Created by KEITA on 16/12/2024.
//

import SwiftUI
import PhotosUI
import UIKit

struct AddEventView: View {
    @State var title = ""
    @State var description = ""
    @State private var date : Date = Date()
    @State var adress : String = ""
    @State var time : String = ""
    @Environment(\.dismiss) var dismiss

    private let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image : UIImage?
    @State var selectedItems : [PhotosPickerItem] = []
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack{
                CustomTexField(text: $title, size: false, placeholder: "New event")
                
                CustomTexField(text: $description,size:false, placeholder: "Tap here entrer your description")
                
                HStack {
                    
                    ZStack(alignment: .leading) {
                               Rectangle()
                                   .frame(width: 171 , height: 56)
                                   .foregroundColor(Color("BackgroundDocument"))
                                   .cornerRadius(10)
                               
                               if date == Date() {
                                   Text("")
                                       .foregroundColor(.white)
                                       .padding(.leading, 5)
                               }
                               
                               DatePicker("", selection: $date, displayedComponents: .date)
                                   .datePickerStyle(.automatic)
                                   .foregroundColor(.white)
                                   .padding(.leading, 5)
                                   .labelsHidden()
                           }
                           .padding(.leading)
                    
                    CustomTexField(text: $time,size:true, placeholder: "HH:MM")
                }
                CustomTexField(text: $adress,size:false, placeholder: "Entre full adress")
                
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
                    }
                }
                .padding()
                
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                }
                else{
                    Text("No image Selected")
                        .font(.headline)
                }
                Spacer()
                Button(action:{}){
                    ZStack {
                        Rectangle()
                            .frame(width: 358, height: 52)
                            .foregroundColor(.red)
                        
                        Text("Selection")
                            .foregroundColor(.white)
                    }
                        
                }
            }
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
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

