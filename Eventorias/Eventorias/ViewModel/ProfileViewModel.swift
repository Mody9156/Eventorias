//
//  ProfileViewModel.swift
//  Eventorias
//
//  Created by KEITA on 23/12/2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var email : String = ""
    @Published var firstName : String = ""
    @Published var lastName : String = ""
}
