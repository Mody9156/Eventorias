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
    var body: some View {
        VStack {
            
            Text("Authentification")
            
            VStack (alignment: .leading){
                Text("Email")
                TextField("name", text:$email)
                Text("Password")
                TextField("password", text:$password)
            }
                Button {
                    
                } label: {
                    Text("Connexion")
                }
        
            
        }.padding()
        
    }
}

struct AuthenficiationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenficiationView()
    }
}
