//
//  CalendarView.swift
//  CalendarView
//
//  Created by Wito Chandra on 05/04/16.
//  Copyright © 2016 Wito Chandra. All rights reserved.
//

import UIKit

public class CalendarView: UIView {
    
    @IBOutlet private var viewBackground: UIView!
    @IBOutlet private var viewTitleContainer: UIView!
    @IBOutlet private var viewDaysOfWeekContainer: UIView!
    @IBOutlet private var viewDivider: UIView!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var labelTitle: UILabel!
    @IBOutlet private var labelSunday: UILabel!
    @IBOutlet private var labelMonday: UILabel!
    @IBOutlet private var labelTuesday: UILabel!
    @IBOutlet private var labelWednesday: UILabel!
    @IBOutlet private var labelThursday: UILabel!
    @IBOutlet private var labelFriday: UILabel!
    @IBOutlet private var labelSaturday: UILabel!
    @IBOutlet private var buttonPrevious: UIButton!
    @IBOutlet private var buttonNext: UIButton!
    
    private var gestureDragDate: UIPanGestureRecognizer!
    
    private var currentFirstDayOfMonth: NSDate
    private var firstDate: NSDate
    private var endDate: NSDate
    
    private var lastFrame = CGRectZero
    private var beginIndex: Int?
    private var endIndex: Int?
    private var draggingBeginDate = false
    
    // MARK: - Public Properties
    
    private var minDate: NSDate {
        didSet {
            firstDate = minDate.firstDayOfCurrentMonth().lastSunday()
        }
    }
    
    private var maxDate = NSDate().dateByAddingDay(365) {
        didSet {
            endDate = maxDate.endDayOfCurrentMonth().nextSaturday()
        }
    }
    
    public var beginDate: NSDate? {
        guard let index = beginIndex else {
            return nil
        }
        return firstDate.dateByAddingDay(index)
    }
    
    public var finishDate: NSDate? {
        guard let index = endIndex else {
            return nil
        }
        return firstDate.dateByAddingDay(index)
    }
    
    public var imagePreviousName = "ic_arrow_left_blue.png" {
        didSet {
            buttonPrevious.setImage(UIImage(named: imagePreviousName), forState: .Normal)
        }
    }
    
    public var imageNextName = "ic_arrow_right_blue.png" {
        didSet {
            buttonNext.setImage(UIImage(named: imageNextName), forState: .Normal)
        }
    }
    
    public var delegate: CalendarViewDelegate?
    
    // MARK: - Constructors
    
    override init(frame: CGRect) {
        minDate = NSDate().normalizeTime()
        maxDate = minDate.dateByAddingDay(365)
        firstDate = minDate.firstDayOfCurrentMonth().lastSunday()
        endDate = maxDate.endDayOfCurrentMonth().dateByAddingDay(7).nextSaturday()
        currentFirstDayOfMonth = minDate.firstDayOfCurrentMonth()
        
        super.init(frame: frame)
        loadViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        minDate = NSDate().normalizeTime()
        maxDate = minDate.dateByAddingDay(365)
        firstDate = minDate.firstDayOfCurrentMonth().lastSunday()
        endDate = maxDate.endDayOfCurrentMonth().dateByAddingDay(7).nextSaturday()
        currentFirstDayOfMonth = minDate.firstDayOfCurrentMonth()
        
        super.init(coder: aDecoder)
        loadViews()
    }
    
    // MARK: - Overrides
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    
        if !CGRectEqualToRect(lastFrame, frame) {
            lastFrame = frame
            collectionView?.reloadData()
        }
        
        collectionView.layoutIfNeeded()
        scrollToMonthOfDate(currentFirstDayOfMonth)
    }
    
    // MARK: - Methods
    
    private func loadViews() {
        let view = CalendarViewUtils.instance.bundle.loadNibNamed("CalendarView", owner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
    
        gestureDragDate = UIPanGestureRecognizer(target: self, action: Selector(stringLiteral: "handleDragDate:"))
        gestureDragDate.delegate = self
        
        collectionView.addGestureRecognizer(gestureDragDate)
        
        collectionView.registerNib(UINib(nibName: "CalendarDayCell", bundle: CalendarViewUtils.instance.bundle), forCellWithReuseIdentifier: "DayCell")
        
        updateMonthYearViews()
        
        reload()
    }
    
    public func scrollToMonthOfDate(date: NSDate) {
        if date.compare(maxDate.firstDayOfCurrentMonth()) != .OrderedDescending && date.compare(firstDate) != .OrderedAscending {
            currentFirstDayOfMonth = date.firstDayOfCurrentMonth()
            let calendar = CalendarViewUtils.instance.calendar
            let diff = calendar.components(.Day, fromDate: firstDate, toDate: currentFirstDayOfMonth, options: [])
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: diff.day, inSection: 0), atScrollPosition: .Top, animated: true)
        }
        collectionView.reloadData()
        updateMonthYearViews()
    }
    
    public func setMinDate(minDate: NSDate, maxDate: NSDate) {
        if minDate.compare(maxDate) != .OrderedAscending {
            fatalError("Min date must be earlier than max date")
        }
        self.minDate = minDate.normalizeTime()
        self.maxDate = maxDate.normalizeTime()
        
        // scrollToMonthOfDate(minDate)
        collectionView.reloadData()
    }
    
    public func setBeginDate(beginDate: NSDate?, finishDate: NSDate?) {
        if beginDate == nil {
            beginIndex = nil
            endIndex = nil
            collectionView.reloadData()
            return
        }
        if let beginDate = beginDate {
            let calendar = CalendarViewUtils.instance.calendar
            let components = calendar.components(.Day, fromDate: firstDate, toDate: beginDate, options: [])
            if beginDate.compare(minDate) != .OrderedAscending {
                beginIndex = components.day
            } else {
                beginIndex = nil
            }
            if let finishDate = finishDate {
                let components = calendar.components(.Day, fromDate: firstDate, toDate: finishDate, options: [])
                if finishDate.compare(maxDate) != .OrderedDescending {
                    endIndex = components.day
                } else {
                    endIndex = nil
                }
            } else {
                endIndex = nil
            }
            collectionView.reloadData()
        }
    }
    
    public func reload() {
        viewTitleContainer.backgroundColor = CalendarViewTheme.instance.bgColorForMonthContainer
        viewDaysOfWeekContainer.backgroundColor = CalendarViewTheme.instance.bgColorForDaysOfWeekContainer
        viewBackground.backgroundColor = CalendarViewTheme.instance.bgColorForOtherMonth
        labelSunday.textColor = CalendarViewTheme.instance.textColorForDayOfWeek
        labelMonday.textColor = CalendarViewTheme.instance.textColorForDayOfWeek
        labelTuesday.textColor = CalendarViewTheme.instance.textColorForDayOfWeek
        labelWednesday.textColor = CalendarViewTheme.instance.textColorForDayOfWeek
        labelThursday.textColor = CalendarViewTheme.instance.textColorForDayOfWeek
        labelFriday.textColor = CalendarViewTheme.instance.textColorForDayOfWeek
        labelSaturday.textColor = CalendarViewTheme.instance.textColorForDayOfWeek
        viewDivider.backgroundColor = CalendarViewTheme.instance.colorForDivider
        
        labelTitle.textColor = CalendarViewTheme.instance.textColorForTitle
        
        collectionView.reloadData()
    }
}

// MARK: - Month View

extension CalendarView {
    
    @IBAction private func buttonPreviousMonthPressed() {
        scrollToPreviousMonth()
    }
    
    @IBAction private func buttonNextMonthPressed() {
        scrollToNextMonth()
    }
    
    private func updateMonthYearViews() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        labelTitle.text = formatter.stringFromDate(currentFirstDayOfMonth)
    }
    
    private func scrollToPreviousMonth() {
        let calendar = CalendarViewUtils.instance.calendar
        let diffComponents = NSDateComponents()
        diffComponents.month = -1
        let date = calendar.dateByAddingComponents(diffComponents, toDate: currentFirstDayOfMonth, options: [])
        if let date = date {
            scrollToMonthOfDate(date)
        }
    }
    
    private func scrollToNextMonth() {
        let calendar = CalendarViewUtils.instance.calendar
        let diffComponents = NSDateComponents()
        diffComponents.month = 1
        let date = calendar.dateByAddingComponents(diffComponents, toDate: currentFirstDayOfMonth, options: [])
        if let date = date {
            scrollToMonthOfDate(date)
        }
    }
}

// MARK: - UICollectionView

extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let calendar = CalendarViewUtils.instance.calendar
        let components = calendar.components(.Day, fromDate: firstDate, toDate: endDate, options: [])
        return components.day + 1
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let date = firstDate.dateByAddingDay(indexPath.row)
        let disabled = date.normalizeTime().compare(minDate) == NSComparisonResult.OrderedAscending
        let state: CalendarDayCellState
        if disabled {
            state = .Disabled
        } else if let beginIndex = beginIndex where beginIndex == indexPath.row {
            state = .Start(hasNext: endIndex != nil)
        } else if let endIndex = endIndex where endIndex == indexPath.row {
            state = .End
        } else if let beginIndex = beginIndex, let endIndex = endIndex where indexPath.row > beginIndex && indexPath.row < endIndex {
            state = .Range
        } else {
            state = .Normal
        }
        let calendar = CalendarViewUtils.instance.calendar
        let components = calendar.components([.Month, .Year], fromDate: date)
        let currentComponents = calendar.components([.Month, .Year], fromDate: currentFirstDayOfMonth)
        let isCurrentMonth = components.month == currentComponents.month && components.year == currentComponents.year
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DayCell", forIndexPath: indexPath) as! CalendarDayCell
        cell.updateWithDate(date, state: state, isCurrentMonth: isCurrentMonth)
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = widthForCellAtIndexPath(indexPath)
        return CGSize(width: width, height: 38)
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CalendarDayCell
        let date = cell.date
        switch cell.state {
        case .Disabled:
            return
        default:
            break
        }
        if beginIndex == nil {
            beginIndex = indexPath.row
            delegate?.calendarView(self, didUpdateBeginDate: date)
        } else if let beginIndex = beginIndex where indexPath.row <= beginIndex && endIndex == nil {
            self.beginIndex = indexPath.row
            delegate?.calendarView(self, didUpdateBeginDate: date)
        } else if let beginIndex = beginIndex where indexPath.row > beginIndex && endIndex == nil {
            endIndex = indexPath.row
            delegate?.calendarView(self, didUpdateFinishDate: date)
            let calendar = CalendarViewUtils.instance.calendar
            let components = calendar.components([.Month, .Year], fromDate: date)
            let currentComponents = calendar.components([.Month, .Year], fromDate: currentFirstDayOfMonth)
            if components.month != currentComponents.month {
                scrollToNextMonth()
            }
        } else if beginIndex != nil && endIndex != nil {
            beginIndex = indexPath.row
            endIndex = nil
            delegate?.calendarView(self, didUpdateBeginDate: date)
            delegate?.calendarView(self, didUpdateFinishDate: nil)
        }
        collectionView.reloadData()
    }
    
    private func widthForCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        let width = bounds.width
        var cellWidth = floor(width / 7)
        if indexPath.row % 7 == 6 {
            cellWidth = cellWidth + (width - (cellWidth * 7))
        }
        return cellWidth
    }
}

extension CalendarView: UIGestureRecognizerDelegate {
    
    public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.locationInView(collectionView)
        if let indexPath = collectionView.indexPathForItemAtPoint(point),
            let beginIndex = beginIndex,
            let endIndex = endIndex
            where indexPath.row == beginIndex || indexPath.row == endIndex
        {
            draggingBeginDate = indexPath.row == beginIndex
            return true
        }
        return false
    }
    
    public func handleDragDate(gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.locationInView(collectionView)
        if let indexPath = collectionView.indexPathForItemAtPoint(point),
                let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CalendarDayCell,
                let beginIndex = beginIndex,
                let endIndex = endIndex
        {
            switch cell.state {
            case .Disabled:
                return
            default:
                break
            }
            let index = indexPath.row
            if draggingBeginDate {
                if index < endIndex {
                    self.beginIndex = index
                } else if index > endIndex {
                    draggingBeginDate = false
                    self.beginIndex = endIndex
                    self.endIndex = index
                }
            } else {
                if index > beginIndex {
                    self.endIndex = index
                } else if index < beginIndex {
                    draggingBeginDate = true
                    self.beginIndex = index
                    self.endIndex = beginIndex
                }
            }
            if self.beginIndex != beginIndex || self.endIndex != endIndex {
                if let index = self.beginIndex where index != beginIndex {
                    delegate?.calendarView(self, didUpdateBeginDate: firstDate.dateByAddingDay(index))
                }
                if let index = self.endIndex where index != endIndex {
                    delegate?.calendarView(self, didUpdateFinishDate: firstDate.dateByAddingDay(index))
                }
                collectionView.reloadData()
            }
        }
    }
}
