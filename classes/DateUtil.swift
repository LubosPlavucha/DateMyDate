//
//  DateUtil.swift
//  HomeBudgetSoft
//
//  Created by lubos plavucha on 08/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation


public class DateUtil {
    
    
    // as of now, swift doesn't have static variables for class -> make use of struct for this
    struct Attributes {

        private static let flags: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond

    }
    
    // INFO: when testing and checking the dates in console, be aware that NSDate is logged in UTC
    
    
    /** get day X months before specified day - time is set to the first second of the day */
    public class func getXMonthsAgo(date: NSDate, monthCount: Int) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        var dateComp = cal.components(Attributes.flags, fromDate: date)
        dateComp.month = dateComp.month - monthCount
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        return cal.dateFromComponents(dateComp)!
    }
    
    
    /** Add number of days to the date */
    public class func addDays(date: NSDate, daysCount: Int) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        var dateComp = NSDateComponents()
        dateComp.day = daysCount
        return cal.dateByAddingComponents(dateComp, toDate: date, options: nil)!
    }
    
    
    /** Add number of weeks to the date */
    public class func addWeeks(date: NSDate, weeksCount: Int) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        var dateComp = NSDateComponents()
        dateComp.weekOfYear = weeksCount
        return cal.dateByAddingComponents(dateComp, toDate: date, options: nil)!
    }
    
    
    /** Add number of months to the date */
    public class func addMonths(date: NSDate, monthsCount: Int) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        var dateComp = NSDateComponents()
        dateComp.month = monthsCount
        return cal.dateByAddingComponents(dateComp, toDate: date, options: nil)!
    }
    
    
    /** Add number of years to the date */
    public class func addYears(date: NSDate, yearCount: Int) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        var dateComp = NSDateComponents()
        dateComp.year = yearCount
        return cal.dateByAddingComponents(dateComp, toDate: date, options: nil)!
    }
    
    
    /** get today - time is set to the first second of the day */
    public class func getBeginningOfDay(date: NSDate) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        var dateComp = cal.components(Attributes.flags, fromDate: date)
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        return cal.dateFromComponents(dateComp)!
    }
    
    
    /** get today - time is set to the last second of the day */
    public class func getEndOfDay(date: NSDate) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        var dateComp = cal.components(Attributes.flags, fromDate: date)
        dateComp.hour = cal.rangeOfUnit(.CalendarUnitHour, inUnit: .CalendarUnitDay, forDate: date).length - 1
        dateComp.minute = cal.rangeOfUnit(.CalendarUnitMinute, inUnit: .CalendarUnitHour, forDate: date).length - 1
        dateComp.second = cal.rangeOfUnit(.CalendarUnitSecond, inUnit: .CalendarUnitMinute, forDate: date).length - 1
        return cal.dateFromComponents(dateComp)!
    }
    
    
    /** get first day of the month - time is set to the first second of the day */
    public class func getFirstDayOfMonth(date: NSDate) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        var dateComp = cal.components(Attributes.flags, fromDate: date)
        dateComp.day = 1
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        return cal.dateFromComponents(dateComp)!
    }
    
    
    /** get last day of the month - time is set to the last second of the day */
    public class func getLastDayOfMonth(date: NSDate) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        var dateComp = cal.components(Attributes.flags, fromDate: date)
        dateComp.day = cal.rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: date).length
        dateComp.hour = cal.rangeOfUnit(.CalendarUnitHour, inUnit: .CalendarUnitDay, forDate: date).length - 1
        dateComp.minute = cal.rangeOfUnit(.CalendarUnitMinute, inUnit: .CalendarUnitHour, forDate: date).length - 1
        dateComp.second = cal.rangeOfUnit(.CalendarUnitSecond, inUnit: .CalendarUnitMinute, forDate: date).length - 1
        return cal.dateFromComponents(dateComp)!
    }
    
    
    /** get first day of the week - time is set to the first second of the day */
    public class func getFirstDayOfWeek(date: NSDate, locale: NSLocale) -> NSDate {
        let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        cal.locale = locale     // locale needs to be used here, because the first day of week depends on it (e.g. Sunday vs. Monday)
        var dateComp = cal.components(Attributes.flags | .CalendarUnitWeekday, fromDate: date)
        dateComp.day = dateComp.day - dateComp.weekday + 1 // workaround, because setting directly weekdays is not working
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        return cal.dateFromComponents(dateComp)!
    }
    
    
    /** get last day of the week - time is set to the last second of the day */
    public class func getLastDayOfWeek(date: NSDate, locale: NSLocale) -> NSDate {
        let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        cal.locale = locale
        var dateComp = cal.components(Attributes.flags | .CalendarUnitWeekday, fromDate: date)
        let weekdayCount = cal.weekdaySymbols.count
        dateComp.day = dateComp.day + (weekdayCount - dateComp.weekday) // workaround, because setting directly weekdays is not working
        dateComp.hour = cal.rangeOfUnit(.CalendarUnitHour, inUnit: .CalendarUnitDay, forDate: date).length - 1
        dateComp.minute = cal.rangeOfUnit(.CalendarUnitMinute, inUnit: .CalendarUnitHour, forDate: date).length - 1
        dateComp.second = cal.rangeOfUnit(.CalendarUnitSecond, inUnit: .CalendarUnitMinute, forDate: date).length - 1
        return cal.dateFromComponents(dateComp)!
    }
    
    
    /** Get next weekday counting from the specified date, e.g. get next Friday from today. If today is the specified weekday, it returns today. */
    public class func getWeekday(date: NSDate, weekdayIndex: Int, locale: NSLocale) -> NSDate {
        let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        cal.locale = locale
        
        var dateComp = cal.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday, fromDate: date)
        
        if weekdayIndex >= dateComp.weekday {
            dateComp.day = dateComp.day + (weekdayIndex - dateComp.weekday)
            return cal.dateFromComponents(dateComp)!
        } else {
            // next weekday is in the next week
            let weekdayCount = cal.weekdaySymbols.count
            dateComp.day = dateComp.day - (dateComp.weekday - weekdayIndex) + weekdayCount
            return cal.dateFromComponents(dateComp)!
        }
    }
    
    
    /** get first day of the year - time is set to the first second of the day */
    public class func getFirstDayOfYear(year: Int) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        var dateComp = NSDateComponents()
        dateComp.year = year
        dateComp.month = 1
        dateComp.day = 1
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        return cal.dateFromComponents(dateComp)!
    }
    
    
    /** get last day of the year - time is set to the last second of the day */
    public class func getLastDayOfYear(year: Int) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        var dateComp = NSDateComponents()
        dateComp.year = year
        dateComp.month = cal.rangeOfUnit(.CalendarUnitMonth, inUnit: .CalendarUnitYear, forDate: cal.dateFromComponents(dateComp)!).length
        dateComp.day = cal.rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: cal.dateFromComponents(dateComp)!).length
        dateComp.hour = cal.rangeOfUnit(.CalendarUnitHour, inUnit: .CalendarUnitDay, forDate: cal.dateFromComponents(dateComp)!).length - 1
        dateComp.minute = cal.rangeOfUnit(.CalendarUnitMinute, inUnit: .CalendarUnitHour, forDate: cal.dateFromComponents(dateComp)!).length - 1
        dateComp.second = cal.rangeOfUnit(.CalendarUnitSecond, inUnit: .CalendarUnitMinute, forDate: cal.dateFromComponents(dateComp)!).length - 1
        return cal.dateFromComponents(dateComp)!
    }

    
    /** get tomorrow - time is set to the first second of the day */
    public class func getTomorrow() -> NSDate {
        let cal = NSCalendar.currentCalendar()
        let today = NSDate()
        var dateComp = cal.components(Attributes.flags, fromDate: today)
        dateComp.day = dateComp.day + 1
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        return cal.dateFromComponents(dateComp)!
    }
    
    
    /** Comparing if first date is before second date ignoring time */
    public class func isBeforeDate(firstDate: NSDate, secondDate: NSDate) -> Bool {
        let firstDateDayBeginning = getBeginningOfDay(firstDate)
        let secondDateDayBeginning = getBeginningOfDay(secondDate)

        let result = firstDateDayBeginning.compare(secondDateDayBeginning)
        if result == .OrderedAscending {
            return true
        }
        return false
    }
    
    
    /** Comparing if first date is before second date or it is same date ignoring time */
    public class func isBeforeOrSameDate(firstDate: NSDate, secondDate: NSDate) -> Bool {
        let firstDateDayBeginning = getBeginningOfDay(firstDate)
        let secondDateDayBeginning = getBeginningOfDay(secondDate)
        
        let result = firstDateDayBeginning.compare(secondDateDayBeginning)
        if result == .OrderedAscending || result == .OrderedSame {
            return true
        }
        return false
    }
    
    
    /** Comparing if first date is after second date ignoring time */
    public class func isAfterDate(firstDate: NSDate, secondDate: NSDate) -> Bool {
        let firstDateDayBeginning = getBeginningOfDay(firstDate)
        let secondDateDayBeginning = getBeginningOfDay(secondDate)
        
        let result = firstDateDayBeginning.compare(secondDateDayBeginning)
        if result == .OrderedDescending {
            return true
        }
        return false
    }
    
    
    /** Comparing if first date is after second date or it is same date ignoring time */
    public class func isAfterOrSameDate(firstDate: NSDate, secondDate: NSDate) -> Bool {
        let firstDateDayBeginning = getBeginningOfDay(firstDate)
        let secondDateDayBeginning = getBeginningOfDay(secondDate)
        
        let result = firstDateDayBeginning.compare(secondDateDayBeginning)
        if result == .OrderedDescending || result == .OrderedSame {
            return true
        }
        return false
    }
    
    
    /** Comparing if first date is same day as second date ignoring time */
    public class func isSameDay(firstDate: NSDate, secondDate: NSDate) -> Bool {
        let firstDateDayBeginning = getBeginningOfDay(firstDate)
        let secondDateDayBeginning = getBeginningOfDay(secondDate)
        
        let result = firstDateDayBeginning.compare(secondDateDayBeginning)
        if result == .OrderedSame {
            return true
        }
        return false
    }
    
    
    /** Comparing if first date is within given month ignoring time */
    public class func isSameMonth(firstDate: NSDate, month: NSDate) -> Bool {
        let cal = NSCalendar.currentCalendar()
        var firsDateComp = cal.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: firstDate)
        var monthDateComp = cal.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: month)
        return firsDateComp.year == monthDateComp.year && firsDateComp.month == monthDateComp.month
    }
    
    
    /** Returns localized month name for given date */
    public class func getMonthName(date: NSDate, locale: NSLocale) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.locale = locale
        let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let monthIndex = cal.components(.CalendarUnitMonth, fromDate: date).month
        return dateFormatter.monthSymbols[monthIndex - 1] as! String
    }
    
}