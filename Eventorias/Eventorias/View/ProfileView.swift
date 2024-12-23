//
//  ProfileView.swift
//  Eventorias
//
//  Created by KEITA on 05/12/2024.
//

import SwiftUI

struct ProfileView: View {
    let user : [User]
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                ForEach(user,id: \.self) { user in
                    Text(user.firstName)
                        .foregroundColor(.white)
                    Text(user.lastName)
                        .foregroundColor(.white)
                    Text(user.email)
                        .foregroundColor(.white)
                }
               
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: [User(firstName: "Modibo", lastName: "KEITA", email: "Modibo.keita@gmail.com", uid: "")])
    }
}
