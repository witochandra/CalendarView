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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        CalendarViewTheme.instance.bgColorForMonthContainer = UIColor(hex: 0xE0E3E6)
        CalendarViewTheme.instance.bgColorForDaysOfWeekContainer = UIColor(hex: 0xE0E3E6)
        CalendarViewTheme.instance.bgColorForCurrentMonth = UIColor(hex: 0xE0E3E6)
        CalendarViewTheme.instance.bgColorForOtherMonth = UIColor(hex: 0xE0E3E6)
        CalendarViewTheme.instance.textColorForTitle = UIColor(hex: 0x334D63)
        CalendarViewTheme.instance.textColorForNormalDay = UIColor(hex: 0x334D63)
        CalendarViewTheme.instance.textColorForDisabledDay = UIColor(hex: 0xB6BCC2)
        CalendarViewTheme.instance.textColorForSelectedDay = UIColor.whiteColor()
        CalendarViewTheme.instance.textColorForDayOfWeek = UIColor(hex: 0x334D63)
        CalendarViewTheme.instance.colorForSelectedDate = UIColor(hex: 0x334D63)
        CalendarViewTheme.instance.colorForDatesRange = UIColor(hex: 0x334D63, alpha: 0.1)
        CalendarViewTheme.instance.colorForDivider = UIColor(hex: 0xCFCFCF)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

