//
//  RegistrationView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI

struct RegistrationView: View {
    @State var email = ""
    @StateObject var authentificationViewModel : AuthentificationViewModel
    
    var body: some View {
        VStack {
            
            Text("Registration")
            
            VStack (alignment: .leading){
                Text("Email")
                TextField("name", text:$email)
                
            }
            Button {
                
            } label: {
                Text("Registration")
            }
            
            
        }.padding()
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(authentificationViewModel: AuthentificationViewModel())
    }
}
