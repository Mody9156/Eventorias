//
//  ErrorDialog.swift
//  Eventorias
//
//  Created by KEITA on 24/12/2024.
//

import SwiftUI

struct ErrorDialog: View {
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                ZStack{
                    Circle()
                        .frame(height: 64)
                        .foregroundColor(Color("BackgroundDocument"))
                    
                    Image(systemName:"exclamationmark")
                        .foregroundColor(.white)
                    
                }
               
                Text("Hello, World!")
            }
        }
    }
}

struct ErrorDialog_Previews: PreviewProvider {
    static var previews: some View {
        ErrorDialog()
    }
}
