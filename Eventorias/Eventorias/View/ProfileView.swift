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
            .toolbar {
                ToolbarItem(placement:.navigationBarLeading) {
                    Text("User Profile")
                        .foregroundColor(.white)
                    
                }
                
                ToolbarItem(placement:.navigationBarTrailing) {
                    if let picture {
                        AsyncImage(url: URL(string:  picture)) { image in
                            image
                                .resizable()
                        } placeholder: {
                            ProgressView()
                            
                        }
                        .frame(width: 40,height: 40)
                        .padding()
                    }
                    
                }
            }
        }
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    @State var name = "Modibo"
    
    static var previews: some View {
        VStack {
            
            ProfileView(loginViewModel: LoginViewModel({}),
                        email: "john.doe@example.com",
                        firstName: "John",
                        lastName: "Doe",
                        picture:"https://upload.wikimedia.org/wikipedia/commons/0/01/Kyrie_Irving_-_51831772061_01_%28cropped%29.jpg")
        }
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
                .padding()
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.custom("Inter", size: 12))
                    .fontWeight(.regular)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .textCase(.none)
                    .foregroundColor(.gray)
                
                Text(text)
                    .foregroundColor(.white)
            }
           
        }
    }
}
