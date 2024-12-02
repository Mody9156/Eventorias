//
//  DateExtension.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation

extension Date {
    static func dateFromString(_ isoString : String)-> Date? {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate]
        
        return isoDateFormatter.date(from: isoString)
    }
    
    static func stringFromDate(_ date : Date ) -> String{
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "dd-MM-yyyy"
        
        return isoDateFormatter.string(from: date)
    }
}
