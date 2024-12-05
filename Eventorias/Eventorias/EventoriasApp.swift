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
    @StateObject private var mainAuth = MainSessionManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack{
                    Color("Background")
                        .ignoresSafeArea()
                //                if mainAuth.isAuthenticated {
                //                    TabView {
                //                        Spacer()
                ListView(eventEntry: EventEntry(picture: "FilmScreening", title: "Book signing", dateCreationString: "2024-11-10T12:00:00Z", poster: "FilmScreeningPoster",description:"Join us for an exclusive Film Screening of [Film Title], a captivating cinematic experience that you won't want to miss! This event will feature a special screening of the critically acclaimed Echoes of the Past, followed by a live Q&A with the director and cast. Whether you're a film enthusiast or simply looking for an entertaining night out, this is your chance to dive into the world of filmmaking, discover behind-the-scenes stories, and engage with the creative minds behind the film. Don’t miss out on this unique opportunity to enjoy a memorable movie night and connect with fellow movie lovers!",hour:"2024-11-10T02:20:00Z", category: "Film", place: Adress(street: "6925 Hollywood Blvd", city: "Los Angeles", posttalCode: "90028", country: "USA")), listViewModel: ListViewModel())
                    .tabItem {
                        HStack {
                            Text("Events")
                            Image("event")
                        }
                    }
                //
                //                        ProfileView()
                //                            .tabItem{
                //                                HStack {
                //                                    Text("Profile")
                //                                    Image(systemName:"person")
                //                                }
                //                            }
                //                        Spacer()
                //                    }
                //                }else{
                //                    HomeView(authentificationViewModel: mainAuth.authentificationViewModel)
                //                        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),removal: .move(edge: .top).combined(with: .opacity)))
                //                }
            }
        }
        }
    }
}
