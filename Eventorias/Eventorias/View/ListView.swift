//
//  ListView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI

struct ListView: View {
    enum focusedTexfield : Hashable {
        case searchable
    }
    let eventEntry :EventEntry
    @State var searchText : String = ""
    @State var isAactive : Bool = false
    @FocusState var focused : focusedTexfield?
    @StateObject var listViewModel : ListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .leading) {
                    Color("Background")
                        .ignoresSafeArea()
                    
                    VStack(alignment: .leading) {
                        CustomButton()
                        
                        ForEach(EventEntry.eventEntry,id: \.self) { entry in
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
                                        
                                        Text("\(listViewModel.formatDateString(eventEntry: eventEntry))")
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
                    .toolbar(content: myTollBarContent)
                    .padding()
                }
            }
            Spacer()
            
        }.onAppear{
            Task{
                try await listViewModel.addEventEntry(eventEntry)
            }
        }
    }
    
    @ToolbarContentBuilder
    func myTollBarContent()-> some ToolbarContent {
        ToolbarItem(placement:.navigationBarLeading){
            HStack {
                ZStack {
                    Rectangle()
                        .frame(width: isAactive ? 300 : 358, height: 35)
                        .foregroundColor(Color("BackgroundDocument"))
                        .cornerRadius(10)
                    
                    HStack{
                        Image(systemName:"magnifyingglass")
                            .foregroundColor(.white)
                        
                        TextField("", text: $searchText,onEditingChanged: { changed in
                            if changed {
                                isAactive = true
                            }else{
                                isAactive = false
                            }
                        })
                        .font(.system(size: 22, weight: .light, design: .default))
                        .background(Color(""))
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .foregroundColor(.white)
                        .overlay(
                            
                            HStack{
                                if searchText.isEmpty {
                                    Text("Search")
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                            }
                        )
                        .focused($focused, equals: .searchable)
                        
                        if !searchText.isEmpty{
                            Button(action:{
                                searchText = ""
                            }){
                                Image(systemName:"multiply.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                }
                if isAactive {
                    Button(action:{
                        isAactive = false
                    }){
                        Text("Annuler")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        
        ToolbarItem(placement: .bottomBar) {
                Button(action:{}){
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.red)
                            .frame(width: 56, height: 56)
                        
                        Image(systemName: "plus")
                            .foregroundColor(.white)
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
