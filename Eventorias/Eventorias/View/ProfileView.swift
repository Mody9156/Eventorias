//
//  ProfileView.swift
//  Eventorias
//
//  Created by KEITA on 05/12/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var loginViewModel : LoginViewModel
    @State var email = UserDefaults.standard.string(forKey:  "userEmail")
    @State var firstName = UserDefaults.standard.string(forKey: "userFirstName")
    @State var lastName = UserDefaults.standard.string(forKey: "userLastName")
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                if let firstName {
                    Text(firstName)
                        .foregroundColor(.white)
                }
                if let lastName {
                    Text(lastName)
                        .foregroundColor(.white)
                }
                if let email {
                    Text(email)
                        .foregroundColor(.white)
                }
                
            }
        }
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(loginViewModel: LoginViewModel({}))
    }
}
