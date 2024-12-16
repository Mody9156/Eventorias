//
//  AddEventView.swift
//  Eventorias
//
//  Created by KEITA on 16/12/2024.
//

import SwiftUI
import PhotosUI

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
    
    @State var selectedItems : [PhotosPickerItem] = []
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack{
                CustomTexField(text: $title, size: false, placeholder: "New event")
                
                CustomTexField(text: $description,size:false, placeholder: "Tap here entrer your description")
                
                HStack {
                    
                    DatePicker("", selection: $date,
                               displayedComponents: .date)
                    .datePickerStyle(.automatic)
                    
                    
                    CustomTexField(text: $time,size:true, placeholder: "HH:MM")
                }
                CustomTexField(text: $adress,size:false, placeholder: "Entre full adress")
                
                HStack(alignment: .center){
                    PhotosPicker(selection:$selectedItems,
                                 matching:.images) {
                        
                        ZStack {
                            Rectangle()
                                .frame(width: 52, height:52)
                                .foregroundColor(.white)
                            
                            Image("Camera")
                        }
                    }
                    Button(action:{}){
                        
                    }
                }
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
                .cornerRadius(5)
            
            VStack(alignment: .leading) {
                Text(placeholder)
                    .foregroundColor(.white)
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
            }
        }
        .padding(.leading)
    }
}
