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
    @StateObject private var viewModelManager = ViewModelManager()
    @State private var selectedTab : Tab = .list
    @State var userIdentity: [UserIdentity] = []  // Initialisez votre tableau d'utilisateurs
    
    enum Tab {
        case list,profil
    }
    
    var body: some Scene {
        WindowGroup {
            if viewModelManager.isAuthenticated {
                TabView(selection: $selectedTab) {
                    NavigationStack {
                        ListView(listViewModel: viewModelManager.listViewModel)
                        
                    }
                    .tabItem {
                        Label("Events", image: "event")
                    }
                    .tag(Tab.list)
                    
                    ProfileView(loginViewModel: viewModelManager.loginViewModel)
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                        .tag(Tab.profil)
                }
                .accentColor(.red)
            }else{
                HomeView(loginViewModel: viewModelManager.loginViewModel)
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),removal: .move(edge: .top).combined(with: .opacity)))
            }
        }
    }
}
