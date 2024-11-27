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
    @State var showOtherButton : Bool = false
    @FocusState private var focusedField : Field?
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
                
            VStack {
                if !showOtherButton {
                    Image("Logo")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    
                    Text("EVENTORIAS")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                
                VStack {
                    if showOtherButton {
                     ActionButtonView(toggle: $toggle,name: "Sign in with email")
                }
                
                Button(action:{
                    showOtherButton.toggle()
                }){
 
                    if !showOtherButton {
                        ZStack {
                            Rectangle()
                                .frame(width:200, height: 50)
                                .foregroundColor(Color("Button"))
                            
                             Image("letter")
                        }
                    }else{
                        
                        Image(systemName:"xmark.circle")
                            .resizable()
                            .foregroundStyle(Color("Button"),Color("Button"))
                            .frame(width: 100, height: 100)
                     }
                 }
                
                if showOtherButton {
                    ActionButtonView(toggle: $toggleRegistre,name: "Registre")
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

struct ActionButtonView: View {
    @Binding var toggle : Bool
    @State var name : String
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width:200, height: 50)
                .foregroundColor(Color("Button"))
            
            HStack {
                
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
