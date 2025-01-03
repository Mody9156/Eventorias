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
                if !listViewModel.isError{
                    HStack {
                        if  !calendar{
                            CustomButton(listViewModel: listViewModel, tryEvent: $tryEvent)
                                .padding()
                        }
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
                }
                else{
                    ErrorDialog(listViewModel: listViewModel)
                        .padding()
                        .transition(.opacity)
                }
                
            }.toolbar(content: myTollBarContent)
        }
    }
    
    @ToolbarContentBuilder
    func myTollBarContent()-> some ToolbarContent {
        if  !calendar{
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

struct ViewCalendar: View {
    @Binding var searchText: String
    @StateObject var listViewModel: ListViewModel
    @State private var selectedDate = Date()
    
    var availableDates: [Date] {
        let allDates = listViewModel.eventEntry.map { $0.dateCreation }
        return Array(Set(allDates)).sorted()
    }
    
    var filteredEvents: [EventEntry] {
        let calendar = Calendar.current
        return listViewModel.eventEntry.filter {
            calendar.isDate($0.dateCreation, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        VStack {
            DatePicker("Sélectionnez une date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .foregroundColor(.white)
                .accentColor(Color("BackgroundDocument"))
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color("Button").opacity(0.5)))
            
            if filteredEvents.isEmpty {
                Text("Aucun événement trouvé pour cette date.")
                    .foregroundColor(.white)
                    .padding()
            } else {
                Text("Date sélectionnée : \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                    .foregroundColor(.white)
                    .padding()
                
                List(filteredEvents, id: \.self) { event in
                    Section {
                        NavigationLink(destination: UserDetailView(eventEntry: event, userDetailViewModel: UserDetailViewModel(eventEntry: [event], listViewModel: ListViewModel(), googleMapView: GoogleMapView()), locationCoordinate: LocationCoordinate())) {
                            HStack(alignment: .top, spacing: 12) {
                                if let picture = event.picture {
                                    Image(picture)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }
                                
                                VStack{
                                    Text(event.title)
                                        .font(.custom("Inter-Medium", size: 16))
                                        .fontWeight(.medium)
                                        .lineLimit(1)
                                        .foregroundColor(.white)
                                    
                                    Text(listViewModel.formatDateString(event.dateCreation))
                                        .font(.custom("Inter-Regular", size: 14))
                                        .foregroundColor(.white)
                                }
                                if let poster = event.poster.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                   let posterURL = URL(string: poster) {
                                    AsyncImage(url: posterURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 120, height: 80)
                                    .cornerRadius(8)
                                }
                                
                                Spacer()
                            }
                            .navigationBarTitle(event.title)
                            .padding(.vertical, 8)
                        }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("BackgroundDocument"))
                            .padding(2)
                    )
                }
                .listStyle(GroupedListStyle())
                .scrollContentBackground(.hidden)
                .background(Color("Background"))
            }
        }
        .onAppear {
            Task {
                try? await listViewModel.getAllProducts()
            }
        }
        .padding()
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
    @Binding var searchText: String
    @StateObject var listViewModel: ListViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(listViewModel.filterTitle(searchText), id: \.self) { entry in
                        HStack {
                            if let picture = entry.picture {
                                Image(picture)
                                    .resizable()
                                    .cornerRadius(50)
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .accessibilityHint("Displays the image for this event")
                                    .accessibilityLabel("Event image")
                                
                                
                            }
                            
                            VStack(alignment: .leading) {
                                Text(entry.title)
                                    .font(.custom("Inter-Medium", size: 16))
                                    .lineSpacing(24 - 16)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                    .truncationMode(.tail)
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                                    .accessibilityLabel("Event title")
                                
                                
                                Text("\(listViewModel.formatDateString(entry.dateCreation))")
                                    .font(.custom("Inter-Regular", size: 14))
                                    .lineSpacing(20 - 14)
                                    .fontWeight(.regular)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.white)
                                    .accessibilityLabel("Event date")
                                
                            }
                            
                            Spacer()
                            if let poster = entry.poster, let posterURL = URL(string: poster) {
                                AsyncImage(url: posterURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(8)
                                        .frame(width: 120, height: 80)
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .accessibilityLabel("Loading event poster")
                                        .accessibilityLabel("Event poster image")
                                        .accessibilityHint("Displays the poster for this event")
                                    
                                }
                            }
                            
                        }
                        .overlay(NavigationLink(destination: {
                            UserDetailView(eventEntry: entry, userDetailViewModel: UserDetailViewModel(eventEntry: [entry], listViewModel: ListViewModel(), googleMapView: GoogleMapView()), locationCoordinate: LocationCoordinate())
                        }, label: {
                            EmptyView()
                        }))
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color("BackgroundDocument"))
                        .frame(width: 358, height: 80)
                        .padding(2)
                )
            }
            .listStyle(GroupedListStyle())
            .scrollContentBackground(.hidden)
            .background(Color("Background"))
            .onAppear {
                Task {
                    try? await listViewModel.getAllProducts()
                }
            }
        }
    }
}
