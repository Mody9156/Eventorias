//
//  EventListRepresentable.swift
//  Eventorias
//
//  Created by KEITA on 03/12/2024.
//

import Foundation

protocol EventListRepresentable{
    func addEvenement(_ eventEntry:EventEntry ) throws
    func tryEvenement()
    func subscribe()
}
