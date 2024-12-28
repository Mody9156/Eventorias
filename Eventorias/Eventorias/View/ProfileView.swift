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
    
    func loadImageFromFile() -> UIImage? {
        guard let picturePath = picture else {
            print("Aucun chemin d'image trouvé dans UserDefaults.")
            return nil
        }
        
        var cleanPath = picturePath
        if cleanPath.hasPrefix("file://") {
            cleanPath = String(cleanPath.dropFirst(7)) // Enlever "file://"
        }
        
        let fileURL = URL(fileURLWithPath: cleanPath)
        print("Chemin nettoyé : \(fileURL.path)")
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: fileURL.path) {
            print("Le fichier n'existe pas à ce chemin : \(fileURL.path)")
            return nil
        }
        
        guard let data = try? Data(contentsOf: fileURL) else {
            print("Impossible de lire les données de l'image.")
            return nil
        }
        
        guard let image = UIImage(data: data) else {
            print("Impossible de convertir les données en UIImage.")
            return nil
        }
        
        return image
    }

    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                VStack {
                    if let lastName, let firstName, let email {
                        InfoSecure(name: "Name", text: "\(firstName) \(lastName)")
                        InfoSecure(name: "E-mail", text: email)
                    }
                    
                    HStack {
                        Toggle("", isOn: $toggle)
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
                        
                        // Chargement de l'image
                        if let image = loadImageFromFile() {
                            Image(uiImage: image)
                                .resizable()
                                .cornerRadius(50)
                                .frame(width: 40, height: 40)
                                .padding()
                        } else {
                            Text("Image non trouvée.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                        Image(uiImage: UIImage(named: "ArtExhibition")!) // Remplacez "placeholder" par le nom d'une image existante dans vos assets.
                            .resizable()
                            .cornerRadius(50)
                            .frame(width: 40, height: 40)
                            .padding()
                        
                       

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
                        Spacer()
                        
                    }
                }
            }
        }
    }
}
    
    //struct MyPreviewProvider_Previews: PreviewProvider {
    //    @State static var name = "Modibo"
    //
    //    static var previews: some View {
    //        ProfileView(
    //            loginViewModel: ,
    //            email: "john.doe@example.com",
    //            firstName: "John",
    //            lastName: "Doe",
    //            picture: "file:///Users/keita/Library/Developer/CoreSimulator/Devices/1714EFF0-B305-4F7A-B14D-5B56802C289A/data/Containers/Data/Application/D108069C-5BEA-4A76-B4FB-1E17C4930BE8/Documents/Harden.jpg"
    //        )
    //    }
    //}
    
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
                .padding(.leading, 34)
            }
        }
    }
