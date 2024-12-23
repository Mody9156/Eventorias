//
//  RegistrationView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI

struct RegistrationView: View {
    @State var email = ""
    @State var password = ""
    @State var firstName = ""
    @State var lastName = ""
    @StateObject var loginViewModel : LoginViewModel
    @Environment(\.dismiss) var dismiss
   
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                Text("Registration")
                    .font(.title)
                    .foregroundColor(.white)
                
                AuthFieldsView(textField: $email, password: $password)
                
                ZStack {
                    Rectangle()
                        .frame(height: 50)
                        .foregroundColor(Color("Button"))
                        
                    
                    Button {
                        loginViewModel.registerUser(email: email, password: password, firtName:firstName, lastName:lastName)
                        if loginViewModel.isAuthenticated {
                            // change
                        }
                        
                    } label: {
                        Image(systemName:"person.fill")
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

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(loginViewModel: LoginViewModel({}))
    }
}

struct AuthFieldsView: View {
    @Binding var textField : String
    @Binding var password : String
    var text : String
    var title : String
    @FocusState private var focusedField : Field?
    
    enum Field : Hashable {
        case email, password, firstName, lastName
    }
    
    var body: some View {
        VStack (alignment: .leading){
            Text(title)
                .foregroundColor(.white)
            if text == "email" {
                TextField(text, text:$textField)
                    .focused($focusedField, equals: .email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            if text == "firstName" {
            TextField(text, text:$textField)
                .focused($focusedField, equals: .email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            if text == "lastName" {
            TextField(text, text:$textField)
                .focused($focusedField, equals: .email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Text("Password")
                .foregroundColor(.white)
            
            SecureField("password", text:$password)
                .focused($focusedField, equals: .password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
