//
//  AuthentificationViewModel.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import Foundation
import FirebaseAuth
import PhotosUI

class LoginViewModel : ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated: Bool = false
    @Published var onLoginSucceed: (() -> ())
    
    let firebaseAuthenticationManager: FirebaseAuthenticationManager
    
    init(_ callback:@escaping (() -> ()), firebaseAuthenticationManager: FirebaseAuthenticationManager) {
        self.onLoginSucceed = callback
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
    }
    
    func login(email: String, password: String) {
        // Validation du mail et du mot de passe
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Veuillez remplir tous les champs."
            print(String(describing: errorMessage))
            return
        }
        
        // Réinitialiser les données utilisateur avant de se connecter
        self.clearUserData()
        
        // Connexion via Firebase
        firebaseAuthenticationManager.signIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }  // Éviter les fuites de mémoire
            
            switch result {
                // Connexion réussie
            case .success(let user):
                DispatchQueue.main.async {
                    // Sauvegarder les informations de l'utilisateur dans UserDefaults
                    self.saveUserData(user)
                }
                self.errorMessage = nil
                self.isAuthenticated = true
                self.onLoginSucceed()
                break
                // Connexion échouée
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isAuthenticated = false
                break
            }
        }
    }
    
    func registerUser(email: String, password: String, firstName: String, lastName: String, picture: String) {
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "L'email ou le mot de passe ne peuvent pas être vides."
            return
        }
        
        firebaseAuthenticationManager.createUser(email: email, password: password, firstName: firstName, lastName: lastName, picture: picture) { result in
            switch result {
                // Création réussie
            case .success(let user):
                self.errorMessage = nil
                print("Utilisateur \(user) a été créé avec succès!")
                break
                // Création échouée
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Voici votre erreur : \(self.errorMessage ?? "Erreur inconnue")")
                break
            }
        }
    }
    
    func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("Échec de la conversion de l'image en données JPEG.")
            return nil
        }

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            print("Image sauvegardée à : \(fileURL.path)")
            return fileURL.path
        } catch {
            print("Erreur lors de la sauvegarde de l'image : \(error)")
            return nil
        }
    }
    
    // Sauvegarder les données de l'utilisateur dans UserDefaults
    private func saveUserData(_ user: User) {
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        UserDefaults.standard.set(user.firstName, forKey: "userFirstName")
        UserDefaults.standard.set(user.lastName, forKey: "userLastName")
        UserDefaults.standard.set(user.picture, forKey: "userPicture")
    }

    // Réinitialiser les données utilisateur dans UserDefaults
    private func clearUserData() {
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userFirstName")
        UserDefaults.standard.removeObject(forKey: "userLastName")
        UserDefaults.standard.removeObject(forKey: "userPicture")
    }
}
