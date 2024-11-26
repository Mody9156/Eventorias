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
            Color("Background").ignoresSafeArea()
            VStack {
                Image("Logo")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
                Text("EVENTORIAS")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                VStack {
                 
                    ActionButtonView(toggle: $toggleRegistre,name: "Sign in with email")
                    ActionButtonView(toggle: $toggleRegistre,name: "Registre")
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

struct ActionButtonView: View {
    @Binding var toggle : Bool
    @State var name : String

    var body: some View {
        ZStack {
            Rectangle()
                .frame(width:200, height: 50)
            
            HStack {
                Image("letter")
                
                Button(action: {
                    
                    toggle.toggle()
                }) {
                    Text(name)
                        .foregroundColor(.white)
                }
                .sheet(isPresented: $toggle, content: {
                    if name == "Registre" {
                        RegistrationView(authentificationViewModel: AuthentificationViewModel())
                    }else{
                        AuthenficiationView( authentificationViewModel: AuthentificationViewModel())
                    }
                    
                })
                
            }
        }.padding()
    }
}
