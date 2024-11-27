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
            Text("Searching for \(searchText) ")
                .navigationTitle("Searchable Example")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
