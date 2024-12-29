//
//  ProfileView.swift
//  Eventorias
//
//  Created by KEITA on 05/12/2024.
//
import SwiftUI

struct ProfileView: View {
    @StateObject var loginViewModel: LoginViewModel
    @State var email = UserDefaults.standard.string(forKey: "userEmail")
    @State var firstName = UserDefaults.standard.string(forKey: "userFirstName")
    @State var lastName = UserDefaults.standard.string(forKey: "userLastName")
    @State var picture = UserDefaults.standard.string(forKey: "userPicture")
    @State var toggle: Bool = false
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                VStack {
                    if let lastName, let firstName, let email {
                        InfoSecure(name: "Name", text: "\(firstName) \(lastName)")
                            .accessibilityLabel("Name: \(firstName) \(lastName)")
                            .accessibilityHint("User's full name displayed.")
                        
                        InfoSecure(name: "E-mail", text: email)
                            .accessibilityLabel("E-mail: \(email)")
                            .accessibilityHint("User's email address displayed.")
                    }
                    
                    HStack {
                        Toggle("", isOn: $toggle)
                            .labelsHidden()
                            .tint(Color("Button"))
                            .padding()
                            .accessibilityLabel("Notifications")
                            .accessibilityHint("Toggle notifications on or off.")
                        
                        Text("Notifications")
                            .font(.custom("Inter-Regular", size: 20))
                            .fontWeight(.bold)
                            .lineSpacing(6)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                            .accessibilityHidden(true)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("User profile")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .lineSpacing(24.2 - 20)
                            .kerning(0.02)
                            .accessibilityLabel("User profile screen")
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if let picture {
                            Image("\(picture)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .accessibilityLabel("Profile picture")
                                .accessibilityHint("User's profile picture.")
                        }
                    }
                }
            }
        }
    }
}

struct InfoSecure: View {
    var name: String
    var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 56)
                .foregroundColor(Color("BackgroundDocument"))
                .cornerRadius(5)
                .padding()
                .accessibilityHidden(true)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.custom("Inter", size: 12))
                    .fontWeight(.regular)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .textCase(.none)
                    .foregroundColor(.gray)
                    .accessibilityLabel("\(name) label")
                
                Text(text)
                    .foregroundColor(.white)
                    .accessibilityLabel("\(name): \(text)")
            }
            .padding(.leading, 34)
        }
    }
}
