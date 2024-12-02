//
//  DateExtension.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation

func dateFromString(_ isoString : String)-> Date? {
    let isoDateFormatter = ISO8601DateFormatter()
    isoDateFormatter.formatOptions = [.withFullDate]
    
    return isoDateFormatter.date(from: isoString)
    
}
