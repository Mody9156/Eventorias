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
    func loadImage(from filePath: String) -> UIImage? {
        // Vérifier si le fichier existe à ce chemin
        let url = URL(fileURLWithPath: filePath)
        return UIImage(contentsOfFile: url.path)
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                VStack{
                    if let lastName, let firstName, let email {
                        InfoSecure(name: "Name", text: "\(firstName) \(lastName)")
                        InfoSecure(name: "E-mail", text: email)
                    }
                    
                    HStack {
                        Toggle("",isOn: $toggle)
                            .labelsHidden()
                            .tint(Color("Button"))
                            .padding()
                        
                        Text("Notifications")
                            .font(.custom("Inter-Regular", size: 20))
                            .fontWeight(.bold)
                            .lineSpacing(6)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                        Spacer()
                        if let picture = picture {
                            AsyncImage(url: URL(string: picture)) { image in
                                image
                                    .resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 136, height: 80)
                            .cornerRadius(12)
                        }
                         
                        
                    }
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement:.navigationBarLeading) {
                        Text("User profile")
                            .font(.custom("Inter", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .lineSpacing(24.2 - 20)
                            .kerning(0.02)
                    }
                    
                    ToolbarItem(placement:.navigationBarTrailing) {
                     
                        
                        
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
                        picture:"https://s3-alpha-sig.figma.com/img/33dc/f227/bd8e6f7b1c88437b6785051d0ee9d205?Expires=1735516800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=LAxAOT0WkB7y7pBwmE5Sw3VAZ3ET9Uyqs8RnUArxX4P5Gb3M1fVxWqdW-yXzcV7cUrHvUtrj-MhiMoKLElzdQ~71JBfTS9Lb3vinV9aJYwPQ7vy~LUIVYvgvuyZaRgg5SdM~0oIOabQN9LcbHjAuJdZ-Y5onvyT5bjMH~z9qz-1F3ulzVTJj4c65r5SCjN0ckxoYZL0OuOQpR81Zqt4ajTQvvUKN39CcAuHVTaTu5mGm2Bxk248V0NCuyRS7NTzHSzF~BMZrNi4AGiHS4bjckIwA1GZGzMM9L3hL6H4M1D3C4ZHjHoqcsFce5om90z0mDXogFnI5PYXis-5GDT3iAg__")
        }
    }
}

struct InfoSecure: View {
    var name : String
    var text : String
    
    var body: some View {
        ZStack(alignment: .leading){
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
            .padding(.leading,34)
        }
        
    }
}
