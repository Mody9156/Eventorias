//
//  ListView.swift
//  Eventorias
//
//  Created by KEITA on 26/11/2024.
//

import SwiftUI
import CoreLocation

struct ListView: View {
    enum FocusedTextField: Hashable {
        case searchable
    }
    @State var searchText: String = ""
    @State var isActive: Bool = false
    @FocusState var focused: FocusedTextField?
    @StateObject var listViewModel: ListViewModel
    @State var tryEvent: Bool = false
    @State var calendar: Bool = false
    
    var filteredEvents: [EventEntry] {
        if searchText.isEmpty {
            return listViewModel.eventEntry
        } else {
            return listViewModel.eventEntry.filter { title in
                title.title.localizedStandardContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color("Background")
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                if !listViewModel.isError {
                    HStack {
                        if !calendar {
                            CustomButton(listViewModel: listViewModel, tryEvent: $tryEvent)
                                .padding()
                        }
                        Spacer()
                        ToggleViewButton(calendar: $calendar)
                            .accessibilityLabel("Toggle between calendar and list view")
                            .accessibilityHint("Switches the display mode")
                    }
                    
                    ZStack(alignment: .bottomTrailing) {
                        if calendar {
                            ViewCalendar(searchText: $searchText, listViewModel: listViewModel)
                        } else {
                            ViewModeList(searchText: $searchText, listViewModel: listViewModel)
                        }
                        
                        HStack {
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
                                        .accessibilityLabel("Add new event")
                                        .accessibilityHint("Navigates to the add event screen")
                                }
                            }
                            .padding()
                        }
                    }
                } else {
                    ErrorDialog(listViewModel: listViewModel)
                        .padding()
                        .transition(.opacity)
                        .accessibilityLabel("An error occurred")
                        .accessibilityHint("Displays an error message")
                }
            }
            .toolbar(content: myToolbarContent)
        }
    }
    
    @ToolbarContentBuilder
    func myToolbarContent() -> some ToolbarContent {
        if !calendar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 358, height: 35)
                            .foregroundColor(Color("BackgroundDocument"))
                            .cornerRadius(10)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .accessibilityLabel("Search icon")
                            
                            TextField("Search", text: $searchText, onEditingChanged: { changed in
                                isActive = changed
                            })
                            .font(.system(size: 22, weight: .light, design: .default))
                            .foregroundColor(.white)
                            .focused($focused, equals: .searchable)
                            .accessibilityLabel("Search field")
                            .accessibilityHint("Enter a search term to filter the events")
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
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
    @StateObject var listViewModel: ListViewModel
    @Binding var tryEvent: Bool
    var picture: Image {
        Image("Sort")
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 105, height: 35)
                .foregroundColor(Color("BackgroundDocument"))
                .cornerRadius(10)
            
            Menu("\(picture) Sorting") {
                ForEach(ListViewModel.FilterOption.allCases, id: \.self) { filter in
                    Button(filter.rawValue) {
                        Task {
                            try? await listViewModel.filterSelected(option: filter)
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .accessibilityLabel("Sort options")
            .accessibilityHint("Choose a sorting method for events")
        }
    }
}
