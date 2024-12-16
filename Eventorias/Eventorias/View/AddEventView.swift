//
//  AddEventView.swift
//  Eventorias
//
//  Created by KEITA on 16/12/2024.
//

import SwiftUI

struct AddEventView: View {
    @State var title = ""
    @State var description = ""
    @State private var date : Date = Date()
    @State var adress : String = ""
    @State var time : String = ""
    
    private let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack(alignment: .leading){
                CustomTexField(text: $title, size: false, placeholder: "New event")
                
                CustomTexField(text: $description,size:false, placeholder: "Tap here entrer your description")
                
                HStack {
                    DatePicker("", selection: $date,
                               displayedComponents: .date)
                    CustomTexField(text: $time,size:true, placeholder: "HH:MM")
                }
                TextField("Entrer full adress", text: $adress)
                CustomTexField(text: $adress,size:false, placeholder: "Entre full adress")
            }
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
    }
}

struct CustomTexField: View {
    @Binding var text : String
    var size : Bool
    var placeholder : String
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: size ? 171 : 358, height: 56)
                .foregroundColor(Color("BackgroundDocument"))
                .cornerRadius(10)
            
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
        }
        .padding()
    }
}
