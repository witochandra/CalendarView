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
    
    public var selectedCircleColor = UIColor(hex: 0x2d4059)
    public var rangeColor = UIColor(hex: 0x2d4059, alpha: 0.5)
    public var normalTextColor = UIColor.blackColor()
    public var disabledTextColor = UIColor(hex: 0xb6bcc2)
    public var selectedTextColor = UIColor.whiteColor()
    public var currentMonthBackgroundColor = UIColor.whiteColor()
    public var notCurrentMonthBackgroundColor = UIColor(hex: 0xedf1f4)
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    
        viewSelectedCircle.backgroundColor = selectedCircleColor
        viewSelectedCircle.layer.cornerRadius = viewSelectedCircle.frame.width / 2
        viewSelectedCircle.layer.masksToBounds = true
        
        viewPreviousRange.backgroundColor = rangeColor
        viewNextRange.backgroundColor = rangeColor
    }
    
    public func updateWithDate(date: NSDate, state: CalendarDayCellState, isCurrentMonth: Bool) {
        self.date = date
        self.state = state
    
        let calendar = CalendarViewUtils.instance.calendar
        let components = calendar.components(.Day, fromDate: date)
        labelDay.text = "\(components.day)"
        
        if isCurrentMonth {
            viewBackground.backgroundColor = currentMonthBackgroundColor
        } else {
            viewBackground.backgroundColor = notCurrentMonthBackgroundColor
        }
        switch state {
        case .Normal:
            if isCurrentMonth {
                labelDay.textColor = normalTextColor
            } else {
                labelDay.textColor = disabledTextColor
            }
            viewSelectedCircle.hidden = true
            viewNextRange.hidden = true
            viewPreviousRange.hidden = true
        case .Disabled:
            labelDay.textColor = disabledTextColor
            viewSelectedCircle.hidden = true
            viewNextRange.hidden = true
            viewPreviousRange.hidden = true
        case let .Start(hasNext):
            labelDay.textColor = selectedTextColor
            viewSelectedCircle.hidden = false
            viewNextRange.hidden = !hasNext
            viewPreviousRange.hidden = true
        case .Range:
            labelDay.textColor = normalTextColor
            viewSelectedCircle.hidden = true
            viewNextRange.hidden = false
            viewPreviousRange.hidden = false
        case .End:
            labelDay.textColor = selectedTextColor
            viewSelectedCircle.hidden = false
            viewNextRange.hidden = true
            viewPreviousRange.hidden = false
        }
    }
}
