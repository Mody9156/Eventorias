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
    
    enum Field : Hashable {
        case email,password
    }
    
    @State var email = ""
    @State var password = ""
    @StateObject var authentificationViewModel : AuthentificationViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField : Field?
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
                
            VStack {
                    Image("Logo")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    
                    Text("EVENTORIAS")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                
                VStack {
                    
                    ZStack {
                        Color("Background")
                            .ignoresSafeArea()
                            .opacity(0.8)
                        
                        VStack {
                            Text("Authentification")
                                .font(.title)
                                .foregroundColor(.white)
                            
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
                            
                            ZStack {
                                Rectangle()
                                    .frame(width:200, height: 50)
                                    .foregroundColor(Color("Button"))
                                
                                Button {
                                    authentificationViewModel.login(email: email, password: password)
                                    
                                } label: {
                                    HStack {
                                        Image("Letter")
                                        Text("Sign in with email")
                                            .foregroundColor(.white)
                                    }
                                }
                                
                            }
                            if let error = authentificationViewModel.errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                            }
                            
                        }.padding()
                    }

//                    AuthenficiationView
//                        ActionButtonView(toggle: $toggle,name: "Sign in with email")
//                    ActionButtonView(toggle: $toggleRegistre,name: "Registre")
             }
        }
        .padding()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(authentificationViewModel: AuthentificationViewModel())
    }
}
//
//struct ActionButtonView: View {
//    @Binding var toggle : Bool
//    @State var name : String
//
//    var body: some View {
//        ZStack {
//
//            Rectangle()
//                .frame(width:200, height: 50)
//                .foregroundColor(Color("Button"))
//
//            HStack {
//
//                Button(action: {
//
//                    toggle.toggle()
//                }) {
//                    Image(name != "Registre" ? "letter" : "")
//                        Text(name)
//                            .foregroundColor(.white)
//                }
//                .sheet(isPresented: $toggle, content: {
//                    if name == "Registre" {
//                        RegistrationView(authentificationViewModel: AuthentificationViewModel())
//                    }
//                })
//            }
//        }.padding()
//    }
//}
