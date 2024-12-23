//
//  ProfileView.swift
//  Eventorias
//
//  Created by KEITA on 05/12/2024.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var loginViewModel : LoginViewModel
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                Text("firstName : \(self.loginViewModel.firstName)")
                    .foregroundColor(.white)
                Text("lastName : \(self.loginViewModel.lastName)")
                    .foregroundColor(.white)
                Text("email : \(self.loginViewModel.email)")
                    .foregroundColor(.white)
            }
        }
    }
}
