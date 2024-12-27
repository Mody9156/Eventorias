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
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
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
                    
                    PhotosPicker(selection: $selectedItems, matching: .images) {
                        ZStack {
                            Rectangle()
                                .frame(width: 52, height: 52)
                                .foregroundColor(Color("Button"))
                                .cornerRadius(16)
                            
                            Image("attach")
                        }
                    }
                    .onChange(of: selectedItems) { newValue in
                        for item in newValue {
                            Task {
                                if let data = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                                    savedFilePath = loginViewModel.saveImageToTemporaryDirectory(image: image, fileName: "\(firstName).jpg")
                                    selectedImage = image
                                }
                            }
                        }
                    }
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 50)
                            .foregroundColor(Color("Button"))
                        
                        Button {
                            if loginViewModel.errorMessage == nil {
                                guard let savedFilePath = savedFilePath else {
                                    return
                                }
                                print("\(savedFilePath)")
                                let fileURL = URL(fileURLWithPath: savedFilePath)
                                let fileURLString = fileURL.absoluteString
                                print("\(fileURLString)")
                                loginViewModel.registerUser(email: email, password: password, firstName: firstName, lastName: lastName, picture: savedFilePath)
                                
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
