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
    @State var bigSize : Bool = false
    @State var smallSize : Bool = true
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
                CustomTexField(text: $title, size: $bigSize, placeholder: "New event")
                
                CustomTexField(text: $description,size:$bigSize, placeholder: "Tap here entrer your description")
                
                HStack {
                    DatePicker("", selection: $date,
                               displayedComponents: .date)
                    CustomTexField(text: $time,size:$smallSize, placeholder: "HH:MM")
                }
                TextField("Entrer full adress", text: $adress)
                CustomTexField(text: $adress,size:$bigSize, placeholder: "Entre full adress")
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
    @Binding var size : Bool
    var placeholder : String
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: 358, height: 56)
                .foregroundColor(Color("BackgroundDocument"))
                .cornerRadius(10)
            
            TextField(placeholder, text: $text)
        }
        .padding()
    }
}
