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

        return true
    }
}

@main
struct EventoriasApp: App {
    @UIApplicationDelegateAdaptor (AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
    }
}
