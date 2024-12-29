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
                        .accessibilityLabel("Eventorias logo") 
                    
                    Text("EVENTORIAS")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .accessibilityLabel("Eventorias title")
                    
                    VStack {
                        fetchCredentials(email: $email, password: $password)
                        
                        ZStack {
                            Rectangle()
                                .frame(height: 50)
                                .foregroundColor(Color("Button"))
                                .accessibilityHidden(true)
                            
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
                            .accessibilityLabel("Sign in with email")
                            .accessibilityHint("Tap to sign in with email")
                        }
                        .padding(.top)
                        
                        if let error = loginViewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .accessibilityLabel("Error message")
                                .accessibilityHint("Displays the login error message")
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
                .accessibilityHidden(true)
            
            NavigationLink {
                RegistrationView(loginViewModel: loginViewModel)
            } label: {
                HStack {
                    Image("letter")
                    Text("Registre")
                        .foregroundColor(.white)
                }
            }
            .accessibilityLabel("Go to registration page")
            .accessibilityHint("Tap to go to the registration page")
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
                .accessibilityLabel("Email label")
            
            TextField("name", text:$email)
                .focused($focusedField, equals: .email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibilityLabel("Enter your email address")
                .accessibilityHint("Enter a valid email address")
                .keyboardType(.emailAddress)
            
            Text("Password")
                .foregroundColor(.white)
                .accessibilityLabel("Password label")
            
            SecureField("password", text: $password)
                .focused($focusedField, equals: .password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibilityLabel("Enter your password")
                .accessibilityHint("Enter a secure password")
        }
    }
}
