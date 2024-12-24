//
//  ListView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI
import CoreLocation

struct ListView: View {
    enum focusedTextfield : Hashable {
        case searchable
    }
    @State var searchText : String = ""
    @State var isActive : Bool = false
    @FocusState var focused : focusedTextfield?
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
                    ToggleViewButton(calendar: $calendar)
                }
                
                ZStack(alignment: .bottomTrailing){
                    
                    if calendar {
                        ViewCalendar(searchText: $searchText, listViewModel: listViewModel)
                    }else{
                        ViewModeList(searchText: $searchText, listViewModel: listViewModel)
                    }
                    ZStack {
                        HStack{
                            Spacer()
                            NavigationLink {
                                AddEventView(addEventViewModel: AddEventViewModel(), locationCoordinate: LocationCoordinate())
                                
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color("Button"))
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
                        .frame(width: 358, height: 35)
                        .foregroundColor(Color("BackgroundDocument"))
                        .cornerRadius(10)
                    
                    HStack{
                        Image(systemName:"magnifyingglass")
                            .foregroundColor(.white)
                            .accessibilityLabel("Search Icon")
                        
                        TextField("", text: $searchText,onEditingChanged: { changed in
                            
                            if changed {
                                isActive = true
                                
                            }else{
                                isActive = false
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

struct MyPreviewProvider_Previewss: PreviewProvider {
    static var previews: some View {
        ListView(listViewModel: ListViewModel.mock())
    }
}
extension ListViewModel {
    static func mock() -> ListViewModel {
        let viewModel = ListViewModel()
        
        viewModel.eventEntry = [
            EventEntry( picture: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/01/Kyrie_Irving_-_51831772061_01_%28cropped%29.jpg/1024px-Kyrie_Irving_-_51831772061_01_%28cropped%29.jpg", title: "NBA", dateCreation: Date.now, poster: "https://img.freepik.com/photos-gratuite/vaisseau-spatial-orbite-autour-planete-dans-superbe-decor-spatial-genere-par-ia_188544-15610.jpg?t=st=1735041951~exp=1735045551~hmac=9a2fa593903e1ecc1fb77937beca379c4f593ad080b7107e495c9cbb4ec72915&w=1800", description: "Une image est une représentation visuelle, voire mentale, de quelque chose (objet, être vivant ou concept).Elle peut être naturelle (ombre, reflet) ou artificielle (sculpture, peinture, photographie), visuelle ou non, tangible ou conceptuelle (métaphore), elle peut entretenir un rapport de ressemblance directe avec son modèle ou au contraire y être liée par un rapport plus symbolique.Pour la sémiologie ou sémiotique, qui a développé tout un secteur de sémiotique visuelle, l'image est conçue comme produite par un langage spécifique.", hour: "12:33", category: "Music", place: Address(street: "112 Av. de la République", city: "Montgeron", postalCode: "91230", country: "FRANCE", localisation: GeoPoint(latitude: 48.862725, longitude: 2.287592)))
        ]
        return viewModel
    }
}

struct ViewCalendar: View {
    @Binding var searchText : String
    @StateObject var listViewModel : ListViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                ForEach(listViewModel.filterTitle(searchText), id: \.self) { entry in
                    NavigationLink(destination: {
                        AddEventView(addEventViewModel: AddEventViewModel(), locationCoordinate: LocationCoordinate())
                    }) {
                        ZStack {
                            AsyncImage(url: URL(string: "\(entry.poster)")) { image in
                                image
                                    .resizable()
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 136, height: 80)
                            }
                            .frame(width: 136, height: 80)
                            .cornerRadius(12)
                            .opacity(0.5)
                            
                            Spacer()
                            
                            Text(entry.title)
                                .font(.custom("Inter-Medium", size: 16))
                                .lineSpacing(24 - 16)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                                .truncationMode(.tail)
                                .lineLimit(1)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct ToggleViewButton: View {
    @Binding var calendar : Bool
    var body: some View {
        Button(action:{
            calendar.toggle()
        }){
            if calendar {
                Image(systemName:"list.bullet")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing,30)
            }else {
                Image(systemName:"rectangle.grid.2x2")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing,30)
            }
        }
        .controlSize(.large)
        .foregroundColor(.white)
        .padding()
    }
}

struct ViewModeList: View {
    @Binding var searchText : String
    @StateObject var listViewModel : ListViewModel
    
    var body: some View {
        List {
            Section {
                ForEach(listViewModel.filterTitle(searchText),id: \.self) { entry in
                    
                    HStack {
                        AsyncImage(url: URL(string: entry.picture)) { image in
                            image
                                .resizable()
                                .cornerRadius(50)
                        } placeholder: {
                            ProgressView()
                            
                        }
                        .frame(width: 40,height: 40)
                        .padding()
                        
                        VStack(alignment:.leading){
                            Text(entry.title)
                                .font(.custom("Inter-Medium", size: 16))
                                .lineSpacing(24 - 16)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                                .truncationMode(.tail)
                                .lineLimit(1)
                                .foregroundColor(.white)
                            
                            Text("\(listViewModel.formatDateString( entry.dateCreation))")
                                .font(.custom("Inter-Regular", size: 14))
                                .lineSpacing(20 - 14)
                                .fontWeight(.regular)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        AsyncImage(url:URL(string:entry.poster)){ image in
                            image
                                .resizable()
                            
                        } placeholder:{
                            ProgressView()
                        }
                        .frame(width: 136, height: 80)
                        .cornerRadius(12)
                        
                    }.overlay(NavigationLink(destination: {
                        UserDetailView(eventEntry: entry, userDetailViewModel: UserDetailViewModel(eventEntry: [entry], listViewModel: ListViewModel(), googleMapView: GoogleMapView()), locationCoordinate: LocationCoordinate())
                    }, label: {
                        EmptyView()
                    }))
                }
            }
            .listRowBackground(
                RoundedRectangle(cornerRadius:16)
                    .fill(Color("BackgroundDocument"))
                    .frame(width: 358, height: 80)
                    .padding(2))
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
}
