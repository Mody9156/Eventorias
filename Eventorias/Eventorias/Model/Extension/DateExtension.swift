//
//  DateExtension.swift
//  Eventorias
//
//  Created by KEITA on 02/12/2024.
//

import Foundation

extension Date {
    static func dateFromString(_ isoString : String)-> Date {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate]
        
        if let date = isoDateFormatter.date(from: isoString) {
            return date
        } else {
            return Date.now
        }
    }
    
    static func hourFromString(_ isoString :String) -> Date{
        let isoHourFormatter = ISO8601DateFormatter()
        isoHourFormatter.formatOptions = [.withInternetDateTime]
        
        if let hour = isoHourFormatter.date(from: isoString) {
            return hour
        } else {
            return Date()
        }
    }
    
    static func stringFromDate(_ date : Date ) -> String{
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "MMM dd, yyyy"
        
        return isoDateFormatter.string(from: date)
    }
    
    static func stringFromHour(_ date : Date) -> String {
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "h:mm a"
        isoDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return isoDateFormatter.string(from: date)
    }
    
    func getDay() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func getMonth() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func getYear() -> Int {
        return Calendar.current.component(.year, from: self)
    }
}

