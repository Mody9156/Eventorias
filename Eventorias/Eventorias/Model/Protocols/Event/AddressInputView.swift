//
//  AddressInputView.swift
//  Eventorias
//
//  Created by KEITA on 18/12/2024.
//

import SwiftUI

struct AddressInputView: View {
    @Binding var street: String
    @Binding var city: String
    @Binding var postalCode: String
    @Binding var country: String
    @Binding var address : String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
        VStack{
            CustomTexField(text: $street, size: false, placeholder: "Entrez le nom de votre rue")
            CustomTexField(text: $city, size: false, placeholder: "Entrez le nom de votre ville")
            CustomTexField(text: $postalCode, size: false, placeholder: "Entrez le le code postale")
            CustomTexField(text: $country, size: false, placeholder: "Entrez le nom de votre pays")
            Text(address)
                .foregroundColor(.white)
            Spacer()
            
            Button(action:{
                self.address = "\(street) \(city) \(postalCode) \(country)"
                dismiss()
              
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
    @State static var sampleAdress : String = ""
    @State static var sampleCity : String = ""
    @State static var samplePostalCode : String = ""
    @State static var sampleCountry: String = ""
    @State static var sampleAddress: String = ""
    
    static var previews: some View {
        AddressInputView(street: $sampleAdress, city: $sampleCity, postalCode: $samplePostalCode, country: $sampleCountry, address: $sampleAddress)
    }
}
