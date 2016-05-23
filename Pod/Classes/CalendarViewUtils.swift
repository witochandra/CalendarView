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
    
    let calendar: NSCalendar
    let bundle: NSBundle
    
    override init() {
        calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = NSTimeZone.localTimeZone()
        let url = NSBundle(forClass: self.dynamicType).URLForResource("WTCalendarView", withExtension: ".bundle")
        bundle = NSBundle(URL: url!)!
        super.init()
    }
}
