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
    @Environment(\.dismiss) var dismiss
    
    
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
                    
                    Text("Password")
                        .foregroundColor(.white)
                    
                    SecureField("password", text:$password)
                        .foregroundColor(.white)
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
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(authentificationViewModel: AuthentificationViewModel())
    }
}
