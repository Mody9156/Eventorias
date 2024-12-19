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
    @StateObject var authentificationViewModel : LoginViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                Text("Registration")
                    .font(.title)
                    .foregroundColor(.white)
                
                AuthFieldsView(email: $email, password: $password)
                
                ZStack {
                    Rectangle()
                        .frame(height: 50)
                        .foregroundColor(Color("Button"))
                        
                    
                    Button {
                        authentificationViewModel.registerUser(email: email, password: password)
                        if authentificationViewModel.isAuthenticated {
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
                
                if let error = authentificationViewModel.errorMessage {
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
        RegistrationView(authentificationViewModel: LoginViewModel({}))
    }
}

struct AuthFieldsView: View {
    @Binding var email : String
    @Binding var password : String
    @FocusState private var focusedField : Field?
    
    enum Field : Hashable {
        case email,password
    }
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Email")
                .foregroundColor(.white)
            
            TextField("email", text:$email)
                .focused($focusedField, equals: .email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("Password")
                .foregroundColor(.white)
            
            SecureField("password", text:$password)
                .focused($focusedField, equals: .password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
