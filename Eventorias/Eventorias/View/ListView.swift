//
//  ListView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI

struct ListView: View {
    @State var searchText : String = ""
    var isActive : String {
        return  "\(Image(systemName: "magnifyingglass"))Search"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .leading) {
                    Color("Background")
                        .ignoresSafeArea()
                    
                    VStack(alignment: .leading) {
                        CustomButton()
                        
                        
                        ForEach(EventEntry.eventEntry) { entry in
                            NavigationLink {
                                UserDetailView(eventEntry: entry)
                            } label: {
                                
                                HStack {
                                    Image(entry.picture)
                                        .resizable()
                                        .frame(width: 40,height: 40)
                                    
                                    VStack{
                                        Text(entry.title)
                                            .font(.custom("Inter-Medium", size: 16))
                                            .lineSpacing(24 - 16)
                                            .fontWeight(.medium)
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(.white)
                                        
                                        Text(entry.dateString)
                                            .font(.custom("Inter-Regular", size: 14))
                                            .lineSpacing(20 - 14)
                                            .fontWeight(.regular)
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    Spacer()
                                    Image(entry.poster)
                                        .resizable()
                                        .frame(width: 136, height: 80)
                                        .cornerRadius(12)
                                    
                                }
                            }
                        }
                        .padding()
                    }
                    .toolbar{
                        ToolbarItem(placement:.navigationBarLeading){
                            ZStack {
                                Rectangle()
                                    .frame(width: 300, height: 26)
                                HStack{
                                    TextField("", text: $searchText)
                                        .font(.system(size: 22, weight: .light, design: .default))
                                        .background(Color(""))
                                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                        .foregroundColor(.white)
                                     
                                }
                                
                            }
                        }
                    }
                    .padding()
                    Spacer()
                }
            }
            
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
