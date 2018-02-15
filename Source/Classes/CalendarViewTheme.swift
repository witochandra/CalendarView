//
//  CalendarViewTheme.swift
//  CalendarView
//
//  Created by Wito Chandra on 06/04/16.
//  Copyright © 2016 Wito Chandra. All rights reserved.
//

import UIKit

open class CalendarViewTheme: NSObject {

    open static let instance = CalendarViewTheme()

    open var bgColorForMonthContainer = UIColor.white
    open var bgColorForDaysOfWeekContainer = UIColor.white
    open var bgColorForCurrentMonth = UIColor.white
    open var bgColorForOtherMonth = UIColor.darkGray
    open var colorForDivider = UIColor.lightGray
    open var colorForSelectedDate = UIColor.black
    open var colorForDatesRange = UIColor(white: 0, alpha: 0.1)
    open var textColorForTitle = UIColor.black
    open var textColorForDayOfWeek = UIColor.black
    open var textColorForNormalDay = UIColor.black
    open var textColorForDisabledDay = UIColor.lightGray
    open var textColorForSelectedDay = UIColor.white
}
