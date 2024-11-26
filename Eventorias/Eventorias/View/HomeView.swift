//
//  ContentView.swift
//  Eventorias
//
//  Created by KEITA on 25/11/2024.
//

import SwiftUI

struct HomeView: View {
    @State var toggle : Bool = false
    @State var toggleRegistre : Bool = false
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("EVENTORIAS")
                
                VStack {
                        
                    ZStack {
                        Rectangle()
                            .frame(width:200,height: 50)
                            .background(Color.red)
                        
                        Button(action: {
                                toggle.toggle()
                            }) {
                                Text("Sign in with email")
                            }
                            .sheet(isPresented: $toggle, content: {
                                AuthenficiationView( authentificationViewModel: AuthentificationViewModel())
                           
                        })
                        
                    }
                
                    ZStack {
                        Rectangle()
                            .frame(width:200,height: 50)
                            
                        
                        HStack {
                            Image("letter")
                            Button(action: {
                                
                                toggleRegistre.toggle()
                            }) {
                                Text("Registre")
                                    .foregroundColor(.white)
                            }
                            .sheet(isPresented: $toggleRegistre, content: {
                                RegistrationView(authentificationViewModel: AuthentificationViewModel())
                           
                        })
                        }
                    }
                }

                
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
