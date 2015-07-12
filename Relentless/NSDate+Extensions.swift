//
//  NSDate+EasyString.swift
//  Relentless
//
//  Created by pixable on 6/22/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

extension NSDate {
    func string() -> String {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .NoStyle
        formatter.dateStyle = .MediumStyle
        return formatter.stringFromDate(self)
    }
    
    func midnights() -> (dayOf: NSDate, nextDay: NSDate) {
        let calendar = NSCalendar.currentCalendar()
        let midnightOnDate = calendar.startOfDayForDate(self)
        let midnightDayAfter = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: 1, toDate: midnightOnDate, options: nil)!
        return (dayOf: midnightOnDate, nextDay: midnightDayAfter)
    }
}
