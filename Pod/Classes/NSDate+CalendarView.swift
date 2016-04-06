//
//  NSDate+CalendarView.swift
//  CalendarView
//
//  Created by Wito Chandra on 05/04/16.
//  Copyright © 2016 Wito Chandra. All rights reserved.
//

import Foundation

extension NSDate {
    
    func dateByAddingDay(day: Int) -> NSDate {
        let calendar = CalendarViewUtils.instance.calendar
        let diff = NSDateComponents()
        diff.day = day
        return calendar.dateByAddingComponents(diff, toDate: self, options: [])!
    }
    
    func lastSunday() -> NSDate {
        let calendar = CalendarViewUtils.instance.calendar
        let components = calendar.components(.Weekday, fromDate: self)
        return dateByAddingDay(1 - components.weekday)
    }
    
    func nextSaturday() -> NSDate {
        let calendar = CalendarViewUtils.instance.calendar
        let components = calendar.components(.Weekday, fromDate: self)
        return dateByAddingDay(7 - components.weekday)
    }
    
    func firstDayOfCurrentMonth() -> NSDate {
        let calendar = CalendarViewUtils.instance.calendar
        let components = calendar.components(.Day, fromDate: self)
        return dateByAddingDay(1 - components.day)
    }
    
    func endDayOfCurrentMonth() -> NSDate {
        let calendar = CalendarViewUtils.instance.calendar
        let diff = NSDateComponents()
        diff.month = 1
        return calendar.dateByAddingComponents(diff, toDate: self, options: [])!
            .firstDayOfCurrentMonth()
            .dateByAddingDay(-1)
    }
    
    func normalizeTime() -> NSDate {
        let calendar = CalendarViewUtils.instance.calendar
        return calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: self, options: [])!
    }
}
