//
//  RegistrationView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI
import PhotosUI

struct RegistrationView: View {
    @State var email = ""
    @State var password = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var picture = ""
    @State var selectedItems : [PhotosPickerItem] = []
    @StateObject  var loginViewModel : LoginViewModel
    @State private var savedFilePath: String?
    @Environment(\.dismiss) var dismiss
    @State private var selectedImage: UIImage? = nil
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var showCamera = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                VStack {
                    Text("Registration")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    AuthFieldsView(textField: $lastName, password: $password, text: "lastName", title: "LastName")
                    AuthFieldsView(textField: $firstName, password: $password, text: "firstName", title: "FirstName")
                    AuthFieldsView(textField: $email, password: $password, text: "email", title: "Email")
                    
                    // Section ajoutée
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(16)
                    } else {
                        Text("Aucune image sélectionnée.")
                            .foregroundColor(.gray)
                    }
                    
                    if isLoading {
                        ProgressView("Chargement...")
                    }
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    
                    
                    Button(action:{
                        self.showCamera.toggle()
                    }){
                        ZStack {
                            Rectangle()
                                .frame(width: 52, height:52)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                            
                            Image("Camera")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .foregroundColor(.black)
                        }
                    }
                    .fullScreenCover(isPresented: self.$showCamera) {
                        accessCameraView(selectedImage: self.$selectedImage)
                            .background(.black)
                    }
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 50)
                            .foregroundColor(Color("Button"))
                        
                        Button {
                            if loginViewModel.errorMessage == nil {
                                
                                // Vérifier que l'image est sélectionnée
                                guard let unwrappedImage = selectedImage else {
                                    errorMessage = "Veuillez sélectionner une image."
                                    return
                                }
                                
                                // Sauvegarder l'image temporairement
                                guard let savedFilePath = loginViewModel.saveImageToTemporaryDirectory(image: unwrappedImage, fileName: "\(UUID().uuidString).jpg") else {
                                    errorMessage = "Échec de la sauvegarde de l'image."
                                    return
                                }
                                
                                print("Chemin de l'image sauvegardée : \(savedFilePath)")
                                
                                // Convertir le chemin en URL String
                                let fileURL = URL(fileURLWithPath: savedFilePath)
                                let fileURLString = fileURL.absoluteString
                                print("URL de l'image : \(fileURLString)")
                                loginViewModel.registerUser(email: email, password: password, firstName: firstName, lastName: lastName, picture: fileURLString)
                                
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                            Text("Registration")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top)
                    
                    if let error = loginViewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
        }
    }
}

struct AuthFieldsView: View {
    @Binding var textField: String
    @Binding var password: String
    var text: String
    var title: String
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case email, password, firstName, lastName
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
            if text == "email" {
                TextField(text, text: $textField)
                    .focused($focusedField, equals: .email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Password")
                    .foregroundColor(.white)
                
                SecureField("password", text: $password)
                    .focused($focusedField, equals: .password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            if text == "firstName" {
                TextField(text, text: $textField)
                    .focused($focusedField, equals: .firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            if text == "lastName" {
                TextField(text, text: $textField)
                    .focused($focusedField, equals: .lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}
