//
//  ViewController.swift
//  CalendarViewDemo
//
//  Created by Wito Chandra on 05/04/16.
//  Copyright © 2016 Wito Chandra. All rights reserved.
//

import UIKit

import CalendarView

class ViewController: UIViewController {

    @IBOutlet var calendarView: CalendarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.titleContainerColor = UIColor.whiteColor()
        calendarView.daysOfWeekContainerColor = UIColor.whiteColor()
        calendarView.delegate = self
        
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.day = 1
        components.month = 1
        components.year = 2016
        calendarView.setMinDate(calendar.dateFromComponents(components)!, maxDate: NSDate(timeIntervalSinceNow: 1000 * 24 * 3600))
        calendarView.setBeginDate(NSDate(), finishDate: NSDate(timeIntervalSinceNow: 24 * 3600))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func buttonTodayPressed() {
        calendarView.setBeginDate(NSDate(), finishDate: NSDate(timeIntervalSinceNow: 24 * 3600))
        calendarView.scrollToMonthOfDate(calendarView.beginDate!)
    }
    
    @IBAction func buttonTomorrowPressed() {
        calendarView.setBeginDate(NSDate(timeIntervalSinceNow: 24 * 3600), finishDate: NSDate(timeIntervalSinceNow: 2 * 24 * 3600))
        calendarView.scrollToMonthOfDate(calendarView.beginDate!)
    }
}

extension ViewController: CalendarViewDelegate {
    
    func calendarView(calendarView: CalendarView, didUpdateBeginDate beginDate: NSDate?) {
        print("Update Begin Date \(beginDate)")
    }
    
    func calendarView(calendarView: CalendarView, didUpdateFinishDate finishDate: NSDate?) {
        print("Update Finish Date \(finishDate)")
    }
}

