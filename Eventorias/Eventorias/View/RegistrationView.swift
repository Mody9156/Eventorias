//
//  RegistrationView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI

struct RegistrationView: View {
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
            Color("Background").ignoresSafeArea()
            VStack {
                Text("Registration")
                    .font(.title)
                    .foregroundColor(.white)
                
                VStack (alignment: .leading){
                    Text("Email")
                        .foregroundColor(.white)
                        
                    TextField("email", text:$email)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Password")
                        .foregroundColor(.white)
                    
                    SecureField("password", text:$password)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                ZStack {
                    Rectangle()
                        .frame(width:200, height: 50)
                        .foregroundColor(Color("Button"))
                    
                    Button {
                        authentificationViewModel.registerUser(email: email, password: password)
                        if authentificationViewModel.isAuthenticated{
                            dismiss()
                        }
                    } label: {
                        Text("Registration")
                            .foregroundColor(.white)
                    }
                }
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
        RegistrationView(authentificationViewModel: AuthentificationViewModel())
    }
}
