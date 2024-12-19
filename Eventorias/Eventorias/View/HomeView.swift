//
//  ContentView.swift
//  Eventorias
//
//  Created by KEITA on 25/11/2024.
//

import SwiftUI

struct HomeView: View {
    @State var toggle : Bool = false
    @State var toggleRegistre : Bool = false
    @State var showOtherButton : Bool = false
    @State var email = ""
    @State var password = ""
    @StateObject var authentificationViewModel : LoginViewModel
    
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
                    
                    Text("EVENTORIAS")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    VStack {
                        fetchCredentials(email: $email, password: $password)
                        
                        ZStack {
                            Rectangle()
                                .frame(height: 50)
                                .foregroundColor(Color("Button"))
                            
                            Button {
                                authentificationViewModel.login(email: email, password: password)
                                
                            } label: {
                                HStack {
                                    Image(systemName:"person.fill")
                                        .foregroundColor(.white)
                                    Text("Sign in with email")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.top)
                        
                        if let error = authentificationViewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                        }
                        
                    }.padding()
                    
                    Spacer()
                    
                    ActionButtonView(toggle: $toggleRegistre)
                }
                .padding()
            }
        }
    }
}


struct ActionButtonView: View {
    @Binding var toggle : Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 50)
                .foregroundColor(Color("Button"))
            
            NavigationLink {
                RegistrationView(authentificationViewModel: LoginViewModel({}))
            } label: {
                HStack {
                    Image("letter")
                    Text("Registre")
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
    }
}

struct fetchCredentials: View {
    @Binding var email : String
    @Binding var password : String
    enum Field : Hashable {
        case email,password
    }
    @FocusState private var focusedField : Field?
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Email")
                .foregroundColor(.white)
            
            TextField("name", text:$email)
                .focused($focusedField, equals: .email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("Password")
                .foregroundColor(.white)
            
            SecureField("password", text: $password)
                .focused($focusedField, equals: .password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
