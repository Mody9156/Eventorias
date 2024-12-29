//
//  ContentView.swift
//  Eventorias
//
//  Created by KEITA on 25/11/2024.
//

import SwiftUI

struct HomeView: View {
    @State var toggle: Bool = false
    @State var toggleRegistre: Bool = false
    @State var showOtherButton: Bool = false
    @State var email = ""
    @State var password = ""
    @StateObject var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Image("Logo")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                        .accessibilityLabel("Eventorias logo") // Label pour l'image du logo
                    
                    Text("EVENTORIAS")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .accessibilityLabel("Eventorias title") // Label pour le texte du titre
                    
                    VStack {
                        fetchCredentials(email: $email, password: $password)
                        
                        ZStack {
                            Rectangle()
                                .frame(height: 50)
                                .foregroundColor(Color("Button"))
                                .accessibilityHidden(true) // Masquer le rectangle décoratif pour VoiceOver
                            
                            Button {
                                loginViewModel.login(email: email, password: password)
                            } label: {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                    Text("Sign in with email")
                                        .foregroundColor(.white)
                                }
                            }
                            .accessibilityLabel("Sign in with email") // Label pour le bouton de connexion
                            .accessibilityHint("Tap to sign in with email") // Indication de l'action
                        }
                        .padding(.top)
                        
                        if let error = loginViewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .accessibilityLabel("Error message") // Label pour le message d'erreur
                                .accessibilityHint("Displays the login error message") // Indication du message d'erreur
                        }
                    }.padding()
                    
                    Spacer()
                    
                    ActionButtonView(toggle: $toggleRegistre, loginViewModel: loginViewModel)
                }
                .padding()
            }
        }
    }
}


struct ActionButtonView: View {
    @Binding var toggle: Bool
    @StateObject var loginViewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 50)
                .foregroundColor(Color("Button"))
                .accessibilityHidden(true) // Masquer le rectangle décoratif pour VoiceOver
            
            NavigationLink {
                RegistrationView(loginViewModel: loginViewModel)
            } label: {
                HStack {
                    Image("letter")
                    Text("Registre")
                        .foregroundColor(.white)
                }
            }
            .accessibilityLabel("Go to registration page") // Label pour le lien de navigation
            .accessibilityHint("Tap to go to the registration page") // Indication de l'action
        }
        .padding()
    }
}

struct fetchCredentials: View {
    @Binding var email: String
    @Binding var password: String
    enum Field: Hashable {
        case email, password
    }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Email")
                .foregroundColor(.white)
                .accessibilityLabel("Email label") // Label pour le champ Email
            
            TextField("name", text:$email)
                .focused($focusedField, equals: .email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibilityLabel("Enter your email address") // Label pour le champ de texte Email
                .accessibilityHint("Enter a valid email address") // Indication pour l'utilisateur
                .keyboardType(.emailAddress) // Spécification du type de clavier pour l'email
            
            Text("Password")
                .foregroundColor(.white)
                .accessibilityLabel("Password label") // Label pour le champ Password
            
            SecureField("password", text: $password)
                .focused($focusedField, equals: .password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibilityLabel("Enter your password") // Label pour le champ de texte Mot de passe
                .accessibilityHint("Enter a secure password") // Indication pour l'utilisateur
        }
    }
}
