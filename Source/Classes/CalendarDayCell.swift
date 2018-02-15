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
    
        viewSelectedCircle.layer.cornerRadius = viewSelectedCircle.frame.width / 2
        viewSelectedCircle.layer.masksToBounds = true
    }
    
    open func update(theme: CalendarViewTheme, date: Date, state: CalendarDayCellState, isCurrentMonth: Bool) {
        self.date = date
        self.state = state
    
        let calendar = CalendarViewUtils.instance.calendar
        let components = (calendar as NSCalendar).components(.day, from: date)
        labelDay.text = String(components.day ?? 0)
        
        viewPreviousRange.backgroundColor = theme.colorForDatesRange
        viewNextRange.backgroundColor = theme.colorForDatesRange
        
        viewSelectedCircle.backgroundColor = theme.colorForSelectedDate
        
        if isCurrentMonth {
            viewBackground.backgroundColor = theme.bgColorForCurrentMonth
        } else {
            viewBackground.backgroundColor = theme.bgColorForOtherMonth
        }
        switch state {
        case .normal:
            if isCurrentMonth {
                labelDay.textColor = theme.textColorForNormalDay
            } else {
                labelDay.textColor = theme.textColorForDisabledDay
            }
            viewSelectedCircle.isHidden = true
            viewNextRange.isHidden = true
            viewPreviousRange.isHidden = true
        case .disabled:
            labelDay.textColor = theme.textColorForDisabledDay
            viewSelectedCircle.isHidden = true
            viewNextRange.isHidden = true
            viewPreviousRange.isHidden = true
        case let .start(hasNext):
            labelDay.textColor = theme.textColorForSelectedDay
            viewSelectedCircle.isHidden = false
            viewNextRange.isHidden = !hasNext
            viewPreviousRange.isHidden = true
        case .range:
            labelDay.textColor = theme.textColorForNormalDay
            viewSelectedCircle.isHidden = true
            viewNextRange.isHidden = false
            viewPreviousRange.isHidden = false
        case .end:
            labelDay.textColor = theme.textColorForSelectedDay
            viewSelectedCircle.isHidden = false
            viewNextRange.isHidden = true
            viewPreviousRange.isHidden = false
        }
    }
}
