//
//  AddressInputView.swift
//  Eventorias
//
//  Created by KEITA on 18/12/2024.
//

import SwiftUI

struct AddressInputView: View {
    @State var street: String = ""
    @State var city: String = ""
//    var postalCode: String
//    var country: String
//    var localisation : GeoPoint
    var body: some View {
        VStack{
            CustomTexField(text: $street, size: false, placeholder: "Entrez le nom de votre rue")
            CustomTexField(text: $city, size: false, placeholder: "Entrez le nom de votre ville")
        }
    }
}

struct AddressInputView_Previews: PreviewProvider {
    static var previews: some View {
        AddressInputView()
    }
}
