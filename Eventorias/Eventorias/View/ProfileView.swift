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
    @State var picture = UserDefaults.standard.string(forKey: "userPicture")
    @State var toggle : Bool = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack{
                if let lastName, let firstName, let email {
                    InfoSecure(name: "Name", text: "\(firstName) \(lastName)")
                    InfoSecure(name: "E-mail", text: email)
                }
                
                Toggle(isOn: $toggle) {
                    Text("Notifications")
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

struct InfoSecure: View {
    var name : String
    var text : String
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(height: 56)
                .foregroundColor(Color("BackgroundDocument"))
                .cornerRadius(5)
            
            VStack(alignment: .leading) {
                Text(text)
                    .font(.custom("Inter", size: 12))
                    .fontWeight(.regular)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .textCase(.none)
                    .foregroundColor(.gray)
                
                Text(name)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
}
