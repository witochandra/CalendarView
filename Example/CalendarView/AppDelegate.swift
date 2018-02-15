//
//  AppDelegate.swift
//  CalendarView
//
//  Created by Wito Chandra on 04/06/2016.
//  Copyright (c) 2016 Wito Chandra. All rights reserved.
//

import UIKit

import WTCalendarView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        CalendarViewTheme.instance.bgColorForMonthContainer = UIColor(hex: 0xE0E3E6)
        CalendarViewTheme.instance.bgColorForDaysOfWeekContainer = UIColor(hex: 0xE0E3E6)
        CalendarViewTheme.instance.bgColorForCurrentMonth = UIColor(hex: 0xE0E3E6)
        CalendarViewTheme.instance.bgColorForOtherMonth = UIColor(hex: 0xE0E3E6)
        CalendarViewTheme.instance.textColorForTitle = UIColor(hex: 0x334D63)
        CalendarViewTheme.instance.textColorForNormalDay = UIColor(hex: 0x334D63)
        CalendarViewTheme.instance.textColorForDisabledDay = UIColor(hex: 0xB6BCC2)
        CalendarViewTheme.instance.textColorForSelectedDay = UIColor.white
        CalendarViewTheme.instance.textColorForDayOfWeek = UIColor(hex: 0x334D63)
        CalendarViewTheme.instance.colorForSelectedDate = UIColor(hex: 0x334D63)
        CalendarViewTheme.instance.colorForDatesRange = UIColor(hex: 0x334D63, alpha: 0.1)
        CalendarViewTheme.instance.colorForDivider = UIColor(hex: 0xCFCFCF)
        
        return true
    }
}



extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

