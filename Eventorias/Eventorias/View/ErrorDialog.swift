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
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct ErrorDialog_Previews: PreviewProvider {
    static var previews: some View {
        ErrorDialog()
    }
}
