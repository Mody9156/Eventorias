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
        isoDateFormatter.dateFormat = "MMM dd, yyyy"
        isoDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return isoDateFormatter.string(from: date)
    }
}
