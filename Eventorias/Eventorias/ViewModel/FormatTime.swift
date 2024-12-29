//
//  FormatTime.swift
//  Eventorias
//
//  Created by KEITA on 29/12/2024.
//

import Foundation

enum FormatTime{
    func formatDateString(_ date:Date) -> String {
        let date = Date.stringFromDate(date)
        return date
    }
    func formatHourString(_ hour:Date) -> String{
        let date = Date.stringFromHour(hour)
        return date
    }
}
