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
    @State var tryEvent : Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .leading) {
                    Color("Background")
                        .ignoresSafeArea()
                    
                    VStack(alignment: .leading) {
                        CustomButton(listViewModel: listViewModel, tryEvent: $tryEvent)
                            .padding()
                        
                        ZStack(alignment: .bottomTrailing) {
                            List {
                                Section {
                                    ForEach(filter,id: \.self) { entry in
                                        
                                        HStack {
                                            Image(entry.picture)
                                                .resizable()
                                                .frame(width: 40,height: 40)
                                                .padding()
                                            
                                            VStack(alignment:.leading){
                                                Text(entry.title)
                                                    .font(.custom("Inter-Medium", size: 16))
                                                    .lineSpacing(24 - 16)
                                                    .fontWeight(.medium)
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundColor(.white)
                                                
                                                Text("\(listViewModel.formatDateString( entry.dateCreation))")
                                                    .font(.custom("Inter-Regular", size: 14))
                                                    .lineSpacing(20 - 14)
                                                    .fontWeight(.regular)
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundColor(.white)
                                            }
                                            
                                            Spacer()
                                            Image(entry.poster)
                                                .resizable()
                                                .frame(width: 136, height: 80)
                                                .cornerRadius(12)
                                            
                                        }.overlay(NavigationLink(destination: {
                                            UserDetailView(eventEntry: entry)
                                        }, label: {
                                            EmptyView()
                                        }))
                                    }
                                    
                                }
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius:16)
                                        .fill(Color("BackgroundDocument"))
                                        .frame(width: 358, height: 80)
                                    
                                        .padding(2)
                                )
                                
                            }
                            .listStyle(GroupedListStyle())
                            .scrollContentBackground(.hidden)
                            .background(Color("Background"))
                            
                            ZStack(alignment:.bottomTrailing) {
                                HStack{
                                    Spacer()
                                    Button(action:{}) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(.red)
                                                .frame(width: 56, height: 56)
                                            Image(systemName: "plus")
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                        
                        
                        
                    }
                    .toolbar(content: myTollBarContent)
                }
                
            }
            Spacer()
            
        }.onAppear{
            //            Task{
            //                try await listViewModel.addEventEntry(eventEntry)
            //            }
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
    }
    var filter: [EventEntry]{
        if searchText.isEmpty {
            return EventEntry.eventEntry
        }else{
            return EventEntry.eventEntry.filter{$0.title.contains(searchText)}
        }
    }
}

//struct ListView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ListView(eventEntry: EventEntry(picture: "TechConference", title: "Tech conference", dateCreationString: "August 5, 2024", poster: "TechConferencePoster"), listViewModel: ListViewModel())
//    }
//}

struct CustomButton: View {
    @StateObject var listViewModel : ListViewModel
    @Binding var tryEvent : Bool
    var body: some View {
        Button(action:{
            
            listViewModel.tryEvent()
        }){
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
