//
//  CalendarViewDelegate.swift
//  CalendarView
//
//  Created by Wito Chandra on 05/04/16.
//  Copyright © 2016 Wito Chandra. All rights reserved.
//

import Foundation

public protocol CalendarViewDelegate {
    
    func calendarView(calendarView: CalendarView, didUpdateBeginDate beginDate: NSDate?)
    func calendarView(calendarView: CalendarView, didUpdateFinishDate finishDate: NSDate?)
}
