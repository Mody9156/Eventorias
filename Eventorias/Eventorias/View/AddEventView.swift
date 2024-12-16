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
            VStack{
                ZStack {
                    Rectangle()
                        .frame(width: 335, height: 56)
                        .foregroundColor(Color("BackgroundDocument"))
                        .cornerRadius(10)
                    
                    TextField("New Event", text: $title)
                }
                TextField("Description", text: $description)
                HStack {
                    DatePicker("", selection: $date,
                               displayedComponents: .date)
                    TextField("HH:MM", text: $time)
                }
                TextField("Entrer full adress", text: $adress)
            }
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
    }
}
