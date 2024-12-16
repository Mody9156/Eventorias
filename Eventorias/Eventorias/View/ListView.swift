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
    @State var searchText : String = ""
    @State var isAactive : Bool = false
    @FocusState var focused : focusedTexfield?
    @StateObject var listViewModel : ListViewModel
    @State var tryEvent : Bool = false
    @State var calendar : Bool = false
    
    var filtreElement : [EventEntry] {
        if searchText.isEmpty{
            return listViewModel.eventEntry
        }else{
            return listViewModel.eventEntry.filter {title in
                title.title.localizedStandardContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading){
            Color("Background")
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    CustomButton(listViewModel: listViewModel, tryEvent: $tryEvent)
                        .padding()
                    Spacer()
                    Button(action:{
                        calendar.toggle()
                    }){
                        Text("Calendar")
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
                
                ZStack(alignment: .bottomTrailing){
                    
                    if calendar {
                        ScrollView {
                            LazyVGrid(columns:Array(repeating: GridItem(.flexible()), count: 2), spacing:5) {
                                
                                ForEach(filtreElement,id: \.self) { entry in
                                    ZStack {
                                        
                                        AsyncImage(url:URL(string:"\(entry.poster)")){ image in
                                            image
                                                .resizable()
                                            
                                        } placeholder:{
                                            
                                        }
                                        .frame(width: 136, height: 80)
                                        .cornerRadius(12)
                                        .opacity(0.5)
                                        
                                        Spacer()
                                        
                                        Text(entry.title)
                                            .lineSpacing(24 - 16)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(.white)
                                        
                                    }.overlay(NavigationLink(destination: {
                                        UserDetailView(eventEntry: entry, userDetailViewModel: UserDetailViewModel(eventEntry: [entry], listViewModel: ListViewModel(), googleMapView: GoogleMapView()))
                                    }, label: {
                                        EmptyView()
                                    }))
                                }
                            }
                            .padding()
                        }
                    }else{
                        List {
                            Section {
                                ForEach(filtreElement,id: \.self) { entry in
                                    
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
                                        AsyncImage(url:URL(string:"\(entry.poster)")){ image in
                                            image
                                                .resizable()
                                            
                                        } placeholder:{
                                            
                                        }
                                        .frame(width: 136, height: 80)
                                        .cornerRadius(12)
                                        
                                        
                                    }.overlay(NavigationLink(destination: {
                                        UserDetailView(eventEntry: entry, userDetailViewModel: UserDetailViewModel(eventEntry: [entry], listViewModel: ListViewModel(), googleMapView: GoogleMapView()))
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
                        .onAppear{
                            Task{
                                try? await listViewModel.getAllProducts()
                            }
                        }
                        .padding()
                    }
                    ZStack {
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
                
                
            }.toolbar(content: myTollBarContent)
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
                            .accessibilityLabel("Search Icon")
                        
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
                                    .accessibilityLabel("Clear search text")
                            }
                        }
                    }
                    .padding()
                }
                
            }
        }
    }
    //    var filter:Any{
    //       listViewModel.tryEvent(keyword: searchText)
    //    }
}


struct CustomButton: View {
    @StateObject var listViewModel : ListViewModel
    @Binding var tryEvent : Bool
    var picture : Image {
        Image("Sort")
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 105, height: 35)
                .foregroundColor(Color("BackgroundDocument"))
                .cornerRadius(10)
                .cornerRadius(35)
            
            Menu("\(picture) Sorting") {
                ForEach(ListViewModel.FilterOption.allCases, id:\.self){ filter in
                    Button(filter.rawValue){
                        Task{
                            try? await listViewModel.filterSelected(option: filter)
                        }
                    }
                }
            }.foregroundColor(.white)
        }
    }
}
//
//struct MyPreviewProvider_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView(eventEntry: EventEntry(picture: "MusicFestival", title: "Music festival", dateCreationString:"2024-06-15T12:00:00Z", poster: "MusicFestivalPoster",description:"Join us for an unforgettable Music Festival celebrating the vibrant sounds of today's most talented artists. This event will feature an exciting lineup of performances, ranging from electrifying live bands to soulful solo acts, offering a diverse and immersive musical experience. Whether you're a devoted music enthusiast or simply looking for a weekend of fun, you'll have the chance to enjoy an eclectic mix of genres and discover emerging talent. Don't miss this opportunity to connect with fellow music lovers and create lasting memories in an energetic, festival atmosphere!",hour:"2024-06-15T12:00:00Z", category: "Music",place: Adress(street: "81-800 Avenue 51", city: "Indio", posttalCode: "92201", country: "USA")), searchText: "", isAactive: true, listViewModel: ListViewModel(), tryEvent: true)
//    }
//}
