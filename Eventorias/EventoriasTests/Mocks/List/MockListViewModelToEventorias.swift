//
//  MockListViewModel.swift
//  EventoriasTests
//
//  Created by KEITA on 28/12/2024.
//

import XCTest
@testable import Eventorias

class MockListViewModelToEventorias {
    var eventEntry: [EventEntry]
    
    init(eventEntry: [EventEntry]) {
        self.eventEntry = eventEntry
    }
}
