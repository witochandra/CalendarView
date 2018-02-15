//
//  NSDate+CalendarView.swift
//  CalendarView
//
//  Created by Wito Chandra on 05/04/16.
//  Copyright © 2016 Wito Chandra. All rights reserved.
//

import Foundation

extension Date {
    
    func dateByAddingDay(_ day: Int) -> Date {
        let calendar = CalendarViewUtils.instance.calendar
        var diff = DateComponents()
        diff.day = day
        return (calendar as NSCalendar).date(byAdding: diff, to: self, options: [])!
    }
    
    func lastSunday() -> Date {
        let calendar = CalendarViewUtils.instance.calendar
        let components = (calendar as NSCalendar).components(.weekday, from: self)
        return dateByAddingDay(1 - components.weekday!)
    }
    
    func nextSaturday() -> Date {
        let calendar = CalendarViewUtils.instance.calendar
        let components = (calendar as NSCalendar).components(.weekday, from: self)
        return dateByAddingDay(7 - components.weekday!)
    }
    
    func firstDayOfCurrentMonth() -> Date {
        let calendar = CalendarViewUtils.instance.calendar
        let components = (calendar as NSCalendar).components(.day, from: self)
        return dateByAddingDay(1 - components.day!)
    }
    
    func endDayOfCurrentMonth() -> Date {
        let calendar = CalendarViewUtils.instance.calendar
        var diff = DateComponents()
        diff.month = 1
        return (calendar as NSCalendar).date(byAdding: diff, to: self, options: [])!
            .firstDayOfCurrentMonth()
            .dateByAddingDay(-1)
    }
    
    func normalizeTime() -> Date {
        let calendar = CalendarViewUtils.instance.calendar
        return (calendar as NSCalendar).date(bySettingHour: 0, minute: 0, second: 0, of: self, options: [])!
    }
}
