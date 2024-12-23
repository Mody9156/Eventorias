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
                    HStack {
                        Text(user.firstName)
                            .foregroundColor(.white)
                        Text(user.lastName)
                            .foregroundColor(.white)
                        Text(user.email)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
               
            }
        }
    }
}
