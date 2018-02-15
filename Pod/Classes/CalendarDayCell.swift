//
//  CalendarDayCell.swift
//  CalendarView
//
//  Created by Wito Chandra on 05/04/16.
//  Copyright © 2016 Wito Chandra. All rights reserved.
//

import UIKit

public enum CalendarDayCellState {
    case normal
    case disabled
    case start(hasNext: Bool)
    case range
    case end
}

open class CalendarDayCell: UICollectionViewCell {
    
    @IBOutlet fileprivate var viewBackground: UIView!
    @IBOutlet fileprivate var viewSelectedCircle: UIView!
    @IBOutlet fileprivate var viewNextRange: UIView!
    @IBOutlet fileprivate var viewPreviousRange: UIView!
    @IBOutlet fileprivate var labelDay: UILabel!
    
    fileprivate(set) var state = CalendarDayCellState.normal
    fileprivate(set) var date = Date()
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    
        viewSelectedCircle.backgroundColor = CalendarViewTheme.instance.colorForSelectedDate
        viewSelectedCircle.layer.cornerRadius = viewSelectedCircle.frame.width / 2
        viewSelectedCircle.layer.masksToBounds = true
        
        viewPreviousRange.backgroundColor = CalendarViewTheme.instance.colorForDatesRange
        viewNextRange.backgroundColor = CalendarViewTheme.instance.colorForDatesRange
    }
    
    open func updateWithDate(_ date: Date, state: CalendarDayCellState, isCurrentMonth: Bool) {
        self.date = date
        self.state = state
    
        let calendar = CalendarViewUtils.instance.calendar
        let components = (calendar as NSCalendar).components(.day, from: date)
        labelDay.text = String(components.day ?? 0)
        
        viewSelectedCircle.backgroundColor = CalendarViewTheme.instance.colorForSelectedDate
        
        if isCurrentMonth {
            viewBackground.backgroundColor = CalendarViewTheme.instance.bgColorForCurrentMonth
        } else {
            viewBackground.backgroundColor = CalendarViewTheme.instance.bgColorForOtherMonth
        }
        switch state {
        case .normal:
            if isCurrentMonth {
                labelDay.textColor = CalendarViewTheme.instance.textColorForNormalDay
            } else {
                labelDay.textColor = CalendarViewTheme.instance.textColorForDisabledDay
            }
            viewSelectedCircle.isHidden = true
            viewNextRange.isHidden = true
            viewPreviousRange.isHidden = true
        case .disabled:
            labelDay.textColor = CalendarViewTheme.instance.textColorForDisabledDay
            viewSelectedCircle.isHidden = true
            viewNextRange.isHidden = true
            viewPreviousRange.isHidden = true
        case let .start(hasNext):
            labelDay.textColor = CalendarViewTheme.instance.textColorForSelectedDay
            viewSelectedCircle.isHidden = false
            viewNextRange.isHidden = !hasNext
            viewPreviousRange.isHidden = true
        case .range:
            labelDay.textColor = CalendarViewTheme.instance.textColorForNormalDay
            viewSelectedCircle.isHidden = true
            viewNextRange.isHidden = false
            viewPreviousRange.isHidden = false
        case .end:
            labelDay.textColor = CalendarViewTheme.instance.textColorForSelectedDay
            viewSelectedCircle.isHidden = false
            viewNextRange.isHidden = true
            viewPreviousRange.isHidden = false
        }
    }
}
