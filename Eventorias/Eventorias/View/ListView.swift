//
//  ListView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI

struct ListView: View {
    @State var searchText : String = ""
    
    var body: some View {
        NavigationStack {
                    ZStack(alignment: .leading) {
                        Color("Background")
                            .ignoresSafeArea()
                        
                        VStack {
                            CustomButton()
                            Spacer()
                            
                        }
                        .padding()
                    }
                    .searchable(text: $searchText, prompt: "Search")
              
                   
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

struct CustomButton: View {
    var body: some View {
        Button(action:{}){
            ZStack {
                Rectangle()
                    .frame(width: 105, height: 35)
                    .cornerRadius(20)
                    .foregroundColor(Color("BackgroundDocument"))
                
                HStack(alignment: .top){
                    Image("Sort")
                        .resizable()
                        .frame(width: 12, height: 16)
                    
                    Text("Sorting")
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
            }
        }
    }
}
