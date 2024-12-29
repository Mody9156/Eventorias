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
    @StateObject var loginViewModel: LoginViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var showCamera = false
    @State private var selectedPicture = "ArtExhibition"
    
    var pictures = ["ArtExhibition", "BookSigning", "CharityRun", "FilmScreening", "FoodFaire", "MusicFestival", "TechConference"]
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                VStack {
                    Text("Registration")
                        .font(.title)
                        .foregroundColor(.white)
                        .accessibilityLabel("Registration Form")
                    
                    AuthFieldsView(textField: $lastName, password: $password, text: "lastName", title: "Last Name")
                    AuthFieldsView(textField: $firstName, password: $password, text: "firstName", title: "First Name")
                    AuthFieldsView(textField: $email, password: $password, text: "email", title: "Email Address")
                    
                    VStack {
                        Text("Choose your Avatar")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .accessibilityLabel("Select your avatar from the grid below")
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(pictures, id: \.self) { picture in
                                    Button(action: {
                                        selectedPicture = picture
                                    }) {
                                        Image(picture)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 50)
                                                    .stroke(selectedPicture == picture ? Color.white : Color.clear, lineWidth: 4)
                                            )
                                    }
                                    .accessibilityLabel(picture)
                                    .accessibilityHint("Double tap to select this avatar.")
                                }
                            }
                            .padding()
                        }
                    }
                    .padding()
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 50)
                            .foregroundColor(Color("Button"))
                        
                        Button {
                            if loginViewModel.errorMessage == nil {
                                loginViewModel.registerUser(email: email, password: password, firstName: firstName, lastName: lastName, picture: selectedPicture)
                                dismiss()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                Text("Register")
                                    .foregroundColor(.white)
                            }
                        }
                        .accessibilityLabel("Register Button")
                        .accessibilityHint("Double tap to complete your registration.")
                    }
                    .padding(.top)
                    
                    if let error = loginViewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .accessibilityLabel("Error: \(error)")
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
                .accessibilityLabel("\(title) Field")
            
            if text == "email" {
                TextField(text, text: $textField)
                    .focused($focusedField, equals: .email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .accessibilityLabel("Enter your email address")
                
                Text("Password")
                    .foregroundColor(.white)
                    .accessibilityLabel("Password Field")
                
                SecureField("Password", text: $password)
                    .focused($focusedField, equals: .password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .accessibilityLabel("Enter your password")
            }
            
            if text == "firstName" {
                TextField(text, text: $textField)
                    .focused($focusedField, equals: .firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .accessibilityLabel("Enter your first name")
            }
            
            if text == "lastName" {
                TextField(text, text: $textField)
                    .focused($focusedField, equals: .lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .accessibilityLabel("Enter your last name")
            }
        }
    }
}
