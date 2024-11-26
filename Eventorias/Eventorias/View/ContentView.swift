//
//  ContentView.swift
//  Eventorias
//
//  Created by KEITA on 25/11/2024.
//

import SwiftUI

struct ContentView: View {
    @State var toggle : Bool = false
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("EVENTORIAS")
                
                Button(action: {
                    toggle.toggle()
                }) {
                    Text("Sign in with email")
                }
                .sheet(isPresented: $toggle, content: {
                    AuthenficiationView()
               
            })

                
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
