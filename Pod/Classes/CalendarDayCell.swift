//
//  CalendarDayCell.swift
//  CalendarView
//
//  Created by Wito Chandra on 05/04/16.
//  Copyright © 2016 Wito Chandra. All rights reserved.
//

import UIKit

public enum CalendarDayCellState {
    case Normal
    case Disabled
    case Start(hasNext: Bool)
    case Range
    case End
}

public class CalendarDayCell: UICollectionViewCell {
    
    @IBOutlet private var viewBackground: UIView!
    @IBOutlet private var viewSelectedCircle: UIView!
    @IBOutlet private var viewNextRange: UIView!
    @IBOutlet private var viewPreviousRange: UIView!
    @IBOutlet private var labelDay: UILabel!
    
    private(set) var state = CalendarDayCellState.Normal
    private(set) var date = NSDate()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    
        viewSelectedCircle.backgroundColor = CalendarViewTheme.instance.colorForSelectedDate
        viewSelectedCircle.layer.cornerRadius = viewSelectedCircle.frame.width / 2
        viewSelectedCircle.layer.masksToBounds = true
        
        viewPreviousRange.backgroundColor = CalendarViewTheme.instance.colorForDatesRange
        viewNextRange.backgroundColor = CalendarViewTheme.instance.colorForDatesRange
    }
    
    public func updateWithDate(date: NSDate, state: CalendarDayCellState, isCurrentMonth: Bool) {
        self.date = date
        self.state = state
    
        let calendar = CalendarViewUtils.instance.calendar
        let components = calendar.components(.Day, fromDate: date)
        labelDay.text = "\(components.day)"
        
        viewSelectedCircle.backgroundColor = CalendarViewTheme.instance.colorForSelectedDate
        
        if isCurrentMonth {
            viewBackground.backgroundColor = CalendarViewTheme.instance.bgColorForCurrentMonth
        } else {
            viewBackground.backgroundColor = CalendarViewTheme.instance.bgColorForOtherMonth
        }
        switch state {
        case .Normal:
            if isCurrentMonth {
                labelDay.textColor = CalendarViewTheme.instance.textColorForNormalDay
            } else {
                labelDay.textColor = CalendarViewTheme.instance.textColorForDisabledDay
            }
            viewSelectedCircle.hidden = true
            viewNextRange.hidden = true
            viewPreviousRange.hidden = true
        case .Disabled:
            labelDay.textColor = CalendarViewTheme.instance.textColorForDisabledDay
            viewSelectedCircle.hidden = true
            viewNextRange.hidden = true
            viewPreviousRange.hidden = true
        case let .Start(hasNext):
            labelDay.textColor = CalendarViewTheme.instance.textColorForSelectedDay
            viewSelectedCircle.hidden = false
            viewNextRange.hidden = !hasNext
            viewPreviousRange.hidden = true
        case .Range:
            labelDay.textColor = CalendarViewTheme.instance.textColorForNormalDay
            viewSelectedCircle.hidden = true
            viewNextRange.hidden = false
            viewPreviousRange.hidden = false
        case .End:
            labelDay.textColor = CalendarViewTheme.instance.textColorForSelectedDay
            viewSelectedCircle.hidden = false
            viewNextRange.hidden = true
            viewPreviousRange.hidden = false
        }
    }
}
