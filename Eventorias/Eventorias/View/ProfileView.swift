//
//  ProfileView.swift
//  Eventorias
//
//  Created by KEITA on 05/12/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var loginViewModel : LoginViewModel
    @State var email = UserDefaults.standard.integer(forKey: "userEmail")
    @State var firstName = UserDefaults.standard.integer(forKey: "userFirstName")
    @State var lastName = UserDefaults.standard.integer(forKey: "userLastName")
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                
                Text("firstName : \(firstName)")
                    .foregroundColor(.white)
                Text("lastName : \(lastName)")
                    .foregroundColor(.white)
                Text("email : \(email)")
                    .foregroundColor(.white)
               
            }
        }
    }
}
