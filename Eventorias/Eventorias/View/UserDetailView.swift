//
//  UserDetailView.swift
//  Eventorias
//
//  Created by KEITA on 01/12/2024.
//

import SwiftUI

struct UserDetailView: View {
    let eventEntry : EventEntry
    var body: some View {
        VStack {
            Text(eventEntry.title)
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(eventEntry: EventEntry(picture: "", title: "", dateString: "", poster: ""))
    }
}
