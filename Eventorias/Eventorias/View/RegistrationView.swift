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
    @StateObject var authentificationViewModel : AuthentificationViewModel
    
    var body: some View {
        VStack {
            Text("Registration")
            .font(.title)
            
            VStack (alignment: .leading){
                Text("Email")
                TextField("email", text:$email)
                
                Text("Password")
                SecureField("password", text:$password)
                
            }
            
            Button {
                
                authentificationViewModel.registerUser(email: email, password: password)
                
            } label: {
                Text("Registration")
            }
            
            
        }
        .padding()
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(authentificationViewModel: AuthentificationViewModel())
    }
}
