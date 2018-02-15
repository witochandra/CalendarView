//
//  CalendarViewDelegate.swift
//  CalendarView
//
//  Created by Wito Chandra on 05/04/16.
//  Copyright © 2016 Wito Chandra. All rights reserved.
//

import Foundation

public protocol CalendarViewDelegate {
    
    func calendarView(_ calendarView: CalendarView, didUpdateBeginDate beginDate: Date?)
    func calendarView(_ calendarView: CalendarView, didUpdateFinishDate finishDate: Date?)
}
