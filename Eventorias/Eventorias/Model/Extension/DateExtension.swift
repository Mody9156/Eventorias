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
        print("Trying to parse: \(isoString)")
               
               if let date = isoDateFormatter.date(from: isoString) {
                   print("super \(date)")
                   return date
               } else {
                   print("Date parsing failed.")
                   return Date.now
               }
    }
    
    static func hourFromString(_ isoString :String) -> Date{
        let isoHourFormatter = ISO8601DateFormatter()
        isoHourFormatter.formatOptions = [.withInternetDateTime]
        print("Trying to parse: \(isoString)")
               
               if let hour = isoHourFormatter.date(from: isoString) {
                   print("super \(hour)")
                   return hour
               } else {
                   print("Date parsing failed.")
            
                   return Date()
               }
    }
    
    static func stringFromDate(_ date : Date ) -> String{
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "MMM dd, yyyy"
        print("Date passé à la méthode : \(date)")  // Vérifie ce qui est passé en paramètre

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

