//
//  ProfileView.swift
//  Eventorias
//
//  Created by KEITA on 05/12/2024.
//

import SwiftUI

struct ProfileView: View {
    @State private var loginViewModel : LoginViewModel
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                Text(loginViewModel.firstName)
                    .foregroundColor(.white)
                Text(loginViewModel.lastName)
                    .foregroundColor(.white)
                Text(loginViewModel.email)
                    .foregroundColor(.white)
            }
        }
    }
}
