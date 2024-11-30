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
            VStack {
                ZStack(alignment: .leading) {
                    Color("Background")
                        .ignoresSafeArea()
                    
                    VStack {
                        CustomButton()

                        ForEach(EventEntry.eventEntry) { entry in
                                NavigationLink {
                                    Text(entry.title)
                                } label: {
                                    
                                        HStack {
                                            Image(entry.picture)
                                                .resizable()
                                                .frame(width: 40,height: 40)
                                            
                                            HStack{
                                                Text(entry.title)
                                                    .font(.custom("Inter-Medium", size: 16))
                                                    .lineSpacing(24 - 16)
                                                    .fontWeight(.medium)
                                                    .multilineTextAlignment(.leading)
                                                    .underline(true, color: .primary)
                                                
                                                Text(entry.dateString)
                                                    .font(.custom("Inter-Regular", size: 14))
                                                    .lineSpacing(20 - 14)
                                                    .fontWeight(.regular)
                                                    .multilineTextAlignment(.leading)
                                                    .underline(true, color: .primary)        

                                            }
                                            Image(entry.poster)
                                                .frame(height: 80)
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                    .padding()
                    }
                    Spacer()
                }
            }
            .searchable(text: $searchText, prompt: "Search")
        }
    }
}

//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView()
//    }
//}

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
