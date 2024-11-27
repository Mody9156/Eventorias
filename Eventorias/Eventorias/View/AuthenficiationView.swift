//
//  AuthenficiationView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI

struct AuthenficiationView: View {
    @State var email = ""
    @State var password = ""
    @StateObject var authentificationViewModel : AuthentificationViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            
            Text("Authentification")
            
            VStack (alignment: .leading){
                Text("Email")
                TextField("name", text:$email)
                
                Text("Password")
                SecureField("password", text: $password)
            }
                Button {
                    authentificationViewModel.login(email: email, password: password)
                    
                    if authentificationViewModel.errorMessage == nil {
                        dismiss()
                    }
                } label: {
                    Text("Connexion")
                }
        
            
        }.padding()
        
    }
}

struct AuthenficiationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenficiationView( authentificationViewModel: AuthentificationViewModel())
    }
}
