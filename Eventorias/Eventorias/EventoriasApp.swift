//
//  EventoriasApp.swift
//  Eventorias
//
//  Created by KEITA on 25/11/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate : NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        if ProcessInfo.processInfo.environment["FIREBASE_AUTH_EMULATOR_HOST"] != nil {
        
        let useEmulator = UserDefaults.standard.bool(forKey: "useEmulator")//Sauvegarde
        if useEmulator {
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
            
            Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        }
    }
     
        return true
    }
}

@main
struct EventoriasApp: App {
    @UIApplicationDelegateAdaptor (AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ListView()
            }
        }
    }
}
