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
    @StateObject  var loginViewModel : LoginViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var showCamera = false
    var pictures = ["ArtExhibition", "BookSigning", "CharityRun", "FilmScreening","FoodFaire","MusicFestival","TechConference"]
    @State private var selectedColor = "Red"
    
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
                    
                    Picker("Please choose a color", selection: $selectedColor) {
                                    ForEach(colors, id: \.self) {
                                        Text($0)
                                    }
                                }
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 50)
                            .foregroundColor(Color("Button"))
                        
                        Button {
                            if loginViewModel.errorMessage == nil {
                            
                                loginViewModel.registerUser(email: email, password: password, firstName: firstName, lastName: lastName, picture: "")
                                
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
