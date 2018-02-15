//
//  CalendarViewUtils.swift
//  CalendarView
//
//  Created by Wito Chandra on 05/04/16.
//  Copyright © 2016 Wito Chandra. All rights reserved.
//

import Foundation

class CalendarViewUtils: NSObject {

    static let instance = CalendarViewUtils()
    
    let calendar: Calendar
    let bundle: Bundle
    
    override init() {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone.autoupdatingCurrent
        self.calendar = calendar
        self.bundle = Bundle(for: CalendarViewUtils.self)
        super.init()
    }
}
