//
//  AuthenficiationView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI

struct AuthenficiationView: View {
    @State var email = ""
    @State var name = ""
    var body: some View {
        VStack {
            Spacer()
            Text("Authentification")
            
            VStack (alignment: .leading){
                Text("Name")
                TextField("name", text:$name)
                Text("Email")
                TextField("email", text:$email)
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
