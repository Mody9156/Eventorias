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
                    
                    Image(systemName:"exclamationmark")
                    
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
