//
//  CalendarView.swift
//  CalendarView
//
//  Created by Wito Chandra on 05/04/16.
//  Copyright © 2016 Wito Chandra. All rights reserved.
//

import UIKit

open class CalendarView: UIView {
    
    @IBOutlet fileprivate var viewBackground: UIView!
    @IBOutlet fileprivate var viewTitleContainer: UIView!
    @IBOutlet fileprivate var viewDaysOfWeekContainer: UIView!
    @IBOutlet fileprivate var viewDivider: UIView!
    @IBOutlet fileprivate var collectionView: UICollectionView!
    @IBOutlet fileprivate var labelTitle: UILabel!
    @IBOutlet fileprivate var labelSunday: UILabel!
    @IBOutlet fileprivate var labelMonday: UILabel!
    @IBOutlet fileprivate var labelTuesday: UILabel!
    @IBOutlet fileprivate var labelWednesday: UILabel!
    @IBOutlet fileprivate var labelThursday: UILabel!
    @IBOutlet fileprivate var labelFriday: UILabel!
    @IBOutlet fileprivate var labelSaturday: UILabel!
    @IBOutlet fileprivate var buttonPrevious: UIButton!
    @IBOutlet fileprivate var buttonNext: UIButton!
    
    fileprivate var gestureDragDate: UIPanGestureRecognizer!
    
    fileprivate var currentFirstDayOfMonth: Date
    fileprivate var firstDate: Date
    fileprivate var endDate: Date
    
    fileprivate var lastFrame = CGRect.zero
    fileprivate var beginIndex: Int?
    fileprivate var endIndex: Int?
    fileprivate var draggingBeginDate = false
    
    fileprivate let dateFormatter = DateFormatter()
    
    fileprivate var minDate: Date {
        didSet {
            firstDate = minDate.firstDayOfCurrentMonth().lastSunday()
        }
    }
    
    fileprivate var maxDate = Date().dateByAddingDay(365) {
        didSet {
            endDate = maxDate.endDayOfCurrentMonth().nextSaturday()
        }
    }
    
    // MARK: - Public Properties
    
    open var beginDate: Date? {
        guard let index = beginIndex else {
            return nil
        }
        return firstDate.dateByAddingDay(index)
    }
    
    open var finishDate: Date? {
        guard let index = endIndex else {
            return nil
        }
        return firstDate.dateByAddingDay(index)
    }
    
    open var imagePreviousName = "ic_arrow_left_blue.png" {
        didSet {
            buttonPrevious.setImage(UIImage(named: imagePreviousName), for: UIControlState())
        }
    }
    
    open var imageNextName = "ic_arrow_right_blue.png" {
        didSet {
            buttonNext.setImage(UIImage(named: imageNextName), for: UIControlState())
        }
    }
    
    open var localeIdentifier: String = "en_US" {
        didSet {
            dateFormatter.locale = Locale(identifier: localeIdentifier)
            reload()
        }
    }
    
    open var theme: CalendarViewTheme = CalendarViewTheme() {
        didSet {
            reload()
        }
    }
    
    open var delegate: CalendarViewDelegate?
    
    // MARK: - Constructors
    
    override init(frame: CGRect) {
        minDate = Date().normalizeTime()
        maxDate = minDate.dateByAddingDay(365)
        firstDate = minDate.firstDayOfCurrentMonth().lastSunday()
        endDate = maxDate.endDayOfCurrentMonth().dateByAddingDay(7).nextSaturday()
        currentFirstDayOfMonth = minDate.firstDayOfCurrentMonth()
        
        super.init(frame: frame)
        loadViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        minDate = Date().normalizeTime()
        maxDate = minDate.dateByAddingDay(365)
        firstDate = minDate.firstDayOfCurrentMonth().lastSunday()
        endDate = maxDate.endDayOfCurrentMonth().dateByAddingDay(7).nextSaturday()
        currentFirstDayOfMonth = minDate.firstDayOfCurrentMonth()
        
        super.init(coder: aDecoder)
        loadViews()
    }
    
    // MARK: - Overrides
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    
        if !lastFrame.equalTo(frame) {
            lastFrame = frame
            collectionView?.reloadData()
        }
        
        collectionView.layoutIfNeeded()
        scrollToMonthOfDate(currentFirstDayOfMonth)
    }
    
    // MARK: - Methods
    
    fileprivate func loadViews() {
        let bundle = Bundle(for: CalendarView.self)
        let view = bundle.loadNibNamed("CalendarView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    
        gestureDragDate = UIPanGestureRecognizer(target: self, action: #selector(CalendarView.handleDragDate(_:)))
        gestureDragDate.delegate = self
        
        collectionView.addGestureRecognizer(gestureDragDate)
        
        collectionView.register(UINib(nibName: "CalendarDayCell", bundle: bundle), forCellWithReuseIdentifier: "DayCell")
        
        reload()
    }
    
    open func scrollToMonthOfDate(_ date: Date) {
        if date.compare(maxDate.firstDayOfCurrentMonth()) != .orderedDescending && date.compare(firstDate) != .orderedAscending {
            currentFirstDayOfMonth = date.firstDayOfCurrentMonth()
            let calendar = CalendarViewUtils.instance.calendar
            let diff = (calendar as NSCalendar).components(.day, from: firstDate, to: currentFirstDayOfMonth, options: [])
            collectionView.scrollToItem(at: IndexPath(row: diff.day!, section: 0), at: .top, animated: true)
        }
        collectionView.reloadData()
        updateMonthYearViews()
    }
    
    open func setMinDate(_ minDate: Date, maxDate: Date) {
        if minDate.compare(maxDate) != .orderedAscending {
            fatalError("Min date must be earlier than max date")
        }
        self.minDate = minDate.normalizeTime()
        self.maxDate = maxDate.normalizeTime()
        
        // scrollToMonthOfDate(minDate)
        collectionView.reloadData()
    }
    
    open func setBeginDate(_ beginDate: Date?, finishDate: Date?) {
        if beginDate == nil {
            beginIndex = nil
            endIndex = nil
            collectionView.reloadData()
            return
        }
        if let beginDate = beginDate {
            let calendar = CalendarViewUtils.instance.calendar
            let components = (calendar as NSCalendar).components(.day, from: firstDate, to: beginDate, options: [])
            if beginDate.compare(minDate) != .orderedAscending {
                beginIndex = components.day
            } else {
                beginIndex = nil
            }
            if let finishDate = finishDate {
                let components = (calendar as NSCalendar).components(.day, from: firstDate, to: finishDate, options: [])
                if finishDate.compare(maxDate) != .orderedDescending {
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
    
    open func reload() {
        viewTitleContainer.backgroundColor = theme.bgColorForMonthContainer
        viewDaysOfWeekContainer.backgroundColor = theme.bgColorForDaysOfWeekContainer
        viewBackground.backgroundColor = theme.bgColorForOtherMonth
        labelSunday.textColor = theme.textColorForDayOfWeek
        labelMonday.textColor = theme.textColorForDayOfWeek
        labelTuesday.textColor = theme.textColorForDayOfWeek
        labelWednesday.textColor = theme.textColorForDayOfWeek
        labelThursday.textColor = theme.textColorForDayOfWeek
        labelFriday.textColor = theme.textColorForDayOfWeek
        labelSaturday.textColor = theme.textColorForDayOfWeek
        viewDivider.backgroundColor = theme.colorForDivider
        
        labelTitle.textColor = theme.textColorForTitle
        
        let date = minDate.lastSunday()
        dateFormatter.dateFormat = "EEEEE"
        labelSunday.text = dateFormatter.string(from: date)
        labelMonday.text = dateFormatter.string(from: date.dateByAddingDay(1))
        labelTuesday.text = dateFormatter.string(from: date.dateByAddingDay(2))
        labelWednesday.text = dateFormatter.string(from: date.dateByAddingDay(3))
        labelThursday.text = dateFormatter.string(from: date.dateByAddingDay(4))
        labelFriday.text = dateFormatter.string(from: date.dateByAddingDay(5))
        labelSaturday.text = dateFormatter.string(from: date.dateByAddingDay(6))
        
        updateMonthYearViews()
        
        collectionView.reloadData()
    }
}

// MARK: - Month View

extension CalendarView {
    
    @IBAction fileprivate func buttonPreviousMonthPressed() {
        scrollToPreviousMonth()
    }
    
    @IBAction fileprivate func buttonNextMonthPressed() {
        scrollToNextMonth()
    }
    
    fileprivate func updateMonthYearViews() {
        dateFormatter.dateFormat = "MMMM yyyy"
        labelTitle.text = dateFormatter.string(from: currentFirstDayOfMonth)
    }
    
    fileprivate func scrollToPreviousMonth() {
        let calendar = CalendarViewUtils.instance.calendar
        var diffComponents = DateComponents()
        diffComponents.month = -1
        let date = (calendar as NSCalendar).date(byAdding: diffComponents, to: currentFirstDayOfMonth, options: [])
        if let date = date {
            scrollToMonthOfDate(date)
        }
    }
    
    fileprivate func scrollToNextMonth() {
        let calendar = CalendarViewUtils.instance.calendar
        var diffComponents = DateComponents()
        diffComponents.month = 1
        let date = (calendar as NSCalendar).date(byAdding: diffComponents, to: currentFirstDayOfMonth, options: [])
        if let date = date {
            scrollToMonthOfDate(date)
        }
    }
}

// MARK: - UICollectionView

extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let calendar = CalendarViewUtils.instance.calendar
        let components = (calendar as NSCalendar).components(.day, from: firstDate, to: endDate, options: [])
        return components.day! + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let date = firstDate.dateByAddingDay(indexPath.row)
        let disabled = date.normalizeTime().compare(minDate) == ComparisonResult.orderedAscending
        let state: CalendarDayCellState
        if disabled {
            state = .disabled
        } else if let beginIndex = beginIndex, beginIndex == indexPath.row {
            state = .start(hasNext: endIndex != nil)
        } else if let endIndex = endIndex, endIndex == indexPath.row {
            state = .end
        } else if let beginIndex = beginIndex, let endIndex = endIndex, indexPath.row > beginIndex && indexPath.row < endIndex {
            state = .range
        } else {
            state = .normal
        }
        let calendar = CalendarViewUtils.instance.calendar
        let components = (calendar as NSCalendar).components([.month, .year], from: date)
        let currentComponents = (calendar as NSCalendar).components([.month, .year], from: currentFirstDayOfMonth)
        let isCurrentMonth = components.month == currentComponents.month && components.year == currentComponents.year
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! CalendarDayCell
        cell.update(theme: theme, date: date, state: state, isCurrentMonth: isCurrentMonth)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = widthForCellAtIndexPath(indexPath)
        return CGSize(width: width, height: 38)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarDayCell
        let date = cell.date
        switch cell.state {
        case .disabled:
            return
        default:
            break
        }
        if beginIndex == nil {
            beginIndex = indexPath.row
            delegate?.calendarView(self, didUpdateBeginDate: date)
        } else if let beginIndex = beginIndex, indexPath.row <= beginIndex && endIndex == nil {
            self.beginIndex = indexPath.row
            delegate?.calendarView(self, didUpdateBeginDate: date)
        } else if let beginIndex = beginIndex, indexPath.row > beginIndex && endIndex == nil {
            endIndex = indexPath.row
            delegate?.calendarView(self, didUpdateFinishDate: date)
            let calendar = CalendarViewUtils.instance.calendar
            let components = (calendar as NSCalendar).components([.month, .year], from: date as Date)
            let currentComponents = (calendar as NSCalendar).components([.month, .year], from: currentFirstDayOfMonth)
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
    
    fileprivate func widthForCellAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        let width = bounds.width
        var cellWidth = floor(width / 7)
        if indexPath.row % 7 == 6 {
            cellWidth = cellWidth + (width - (cellWidth * 7))
        }
        return cellWidth
    }
}

extension CalendarView: UIGestureRecognizerDelegate {
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point),
            let beginIndex = beginIndex,
            let endIndex = endIndex, indexPath.row == beginIndex || indexPath.row == endIndex
        {
            draggingBeginDate = indexPath.row == beginIndex
            return true
        }
        return false
    }
    
    @objc public func handleDragDate(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point),
                let cell = collectionView.cellForItem(at: indexPath) as? CalendarDayCell,
                let beginIndex = beginIndex,
                let endIndex = endIndex
        {
            switch cell.state {
            case .disabled:
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
                if let index = self.beginIndex, index != beginIndex {
                    delegate?.calendarView(self, didUpdateBeginDate: firstDate.dateByAddingDay(index))
                }
                if let index = self.endIndex, index != endIndex {
                    delegate?.calendarView(self, didUpdateFinishDate: firstDate.dateByAddingDay(index))
                }
                collectionView.reloadData()
            }
        }
    }
}
