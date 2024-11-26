//
//  AuthenficiationView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI

struct AuthenficiationView: View {
    @State var email = ""
    @State var name = ""
    var body: some View {
        Text("Hello, World!")
        TextField("name", text:$name)
        TextField("email", text:$email)
    }
}

struct AuthenficiationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenficiationView()
    }
}
