//
//  ProfileView.swift
//  Eventorias
//
//  Created by KEITA on 05/12/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var loginViewModel : LoginViewModel
    let userIdentity : [UserIdentity]
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                if let firstName = loginViewModel.firstName {
                    Text("firstName : \(firstName)")
                        .foregroundColor(.white)
                }
                if let lastName = loginViewModel.lastName {
                    Text("lastName : \(lastName)")
                        .foregroundColor(.white)
                }
                if let email = loginViewModel.email {
                    Text("email : \(email)")
                        .foregroundColor(.white)
                }
              
            }
        }
    }
}
