//
//  AuthenficiationView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI

struct AuthenficiationView: View {
    enum Field : Hashable {
        case email,password
    }
    
    @State var email = ""
    @State var password = ""
    @StateObject var authentificationViewModel : AuthentificationViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField : Field?

    var body: some View {
        VStack {
            Text("Authentification")
            
            VStack (alignment: .leading){
                Text("Email")
                TextField("name", text:$email)
                    .focused($focusedField, equals: .email)
                
                Text("Password")
                SecureField("password", text: $password)
                    .focused($focusedField, equals: .password)
            }
            
            Button {
                authentificationViewModel.login(email: email, password: password)
                
                if authentificationViewModel.isAuthenticated{
                    dismiss()
                }
                
            } label: {
                Text("Connexion")
            }
            if let error = authentificationViewModel.errorMessage {
                Text(error)
                .foregroundColor(.red)
        }
        }.padding()
    }
}

struct AuthenficiationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenficiationView( authentificationViewModel: AuthentificationViewModel())
    }
}
