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
    @State var postalCode: String = ""
    @State var country: String = ""
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
        VStack{
            CustomTexField(text: $street, size: false, placeholder: "Entrez le nom de votre rue")
            CustomTexField(text: $city, size: false, placeholder: "Entrez le nom de votre ville")
            CustomTexField(text: $city, size: false, placeholder: "Entrez le le code postale")
            CustomTexField(text: $city, size: false, placeholder: "Entrez le nom de votre pays")
            
            Spacer()
            
            Button(action:{
               
            }){
                ZStack {
                    Rectangle()
                        .frame(width: 358, height: 52)
                        .foregroundColor(Color("Button"))
                    
                    Text("Validate")
                        .foregroundColor(.white)
                }
                
            }
        }
    }
    }
}

struct AddressInputView_Previews: PreviewProvider {
    static var previews: some View {
        AddressInputView()
    }
}
