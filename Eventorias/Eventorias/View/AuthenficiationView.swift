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
            Text("Authentification")
            
            VStack (alignment: .leading){
                Text("Name")
                TextField("name", text:$name)
                Text("Email")
                TextField("email", text:$email)
            }
            
        }.padding()
        
    }
}

struct AuthenficiationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenficiationView()
    }
}
