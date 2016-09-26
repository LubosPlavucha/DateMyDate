//
//  DateUtil.swift
//  HomeBudgetSoft
//
//  Created by lubos plavucha on 08/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation


open class DateUtil {
    
    
    // as of now, swift doesn't have static variables for class -> make use of struct for this
    struct Attributes {

        fileprivate static let flags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]

    }
    
    // INFO: when testing and checking the dates in console, be aware that NSDate is logged in UTC
    
    
    /** get day X months before specified day - time is set to the first second of the day */
    open class func getXMonthsAgo(_ date: Date, monthCount: Int) -> Date {
        let cal = Calendar.current
        var dateComp = (cal as NSCalendar).components(Attributes.flags, from: date)
        dateComp.month = dateComp.month! - monthCount
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        return cal.date(from: dateComp)!
    }
    
    
    /** Add number of days to the date */
    open class func addDays(_ date: Date, daysCount: Int) -> Date {
        let cal = Calendar.current
        var dateComp = DateComponents()
        dateComp.day = daysCount
        return (cal as NSCalendar).date(byAdding: dateComp, to: date, options: [])!
    }
    
    
    /** Add number of weeks to the date */
    open class func addWeeks(_ date: Date, weeksCount: Int) -> Date {
        let cal = Calendar.current
        var dateComp = DateComponents()
        dateComp.weekOfYear = weeksCount
        return (cal as NSCalendar).date(byAdding: dateComp, to: date, options: [])!
    }
    
    
    /** Add number of months to the date */
    open class func addMonths(_ date: Date, monthsCount: Int) -> Date {
        let cal = Calendar.current
        var dateComp = DateComponents()
        dateComp.month = monthsCount
        return (cal as NSCalendar).date(byAdding: dateComp, to: date, options: [])!
    }
    
    
    /** Add number of years to the date */
    open class func addYears(_ date: Date, yearCount: Int) -> Date {
        let cal = Calendar.current
        var dateComp = DateComponents()
        dateComp.year = yearCount
        return (cal as NSCalendar).date(byAdding: dateComp, to: date, options: [])!
    }
    
    
    /** get today - time is set to the first second of the day */
    open class func getBeginningOfDay(_ date: Date) -> Date {
        let cal = Calendar.current
        var dateComp = (cal as NSCalendar).components(Attributes.flags, from: date)
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        return cal.date(from: dateComp)!
    }
    
    
    /** get today - time is set to the last second of the day */
    open class func getEndOfDay(_ date: Date) -> Date {
        let cal = Calendar.current
        var dateComp = (cal as NSCalendar).components(Attributes.flags, from: date)
        dateComp.hour = (cal as NSCalendar).range(of: .hour, in: .day, for: date).length - 1
        dateComp.minute = (cal as NSCalendar).range(of: .minute, in: .hour, for: date).length - 1
        dateComp.second = (cal as NSCalendar).range(of: .second, in: .minute, for: date).length - 1
        return cal.date(from: dateComp)!
    }
    
    
    /** get first day of the month - time is set to the first second of the day */
    open class func getFirstDayOfMonth(_ date: Date) -> Date {
        let cal = Calendar.current
        var dateComp = (cal as NSCalendar).components(Attributes.flags, from: date)
        dateComp.day = 1
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        return cal.date(from: dateComp)!
    }
    
    
    /** get last day of the month - time is set to the last second of the day */
    open class func getLastDayOfMonth(_ date: Date) -> Date {
        let cal = Calendar.current
        var dateComp = (cal as NSCalendar).components(Attributes.flags, from: date)
        dateComp.day = (cal as NSCalendar).range(of: .day, in: .month, for: date).length
        dateComp.hour = (cal as NSCalendar).range(of: .hour, in: .day, for: date).length - 1
        dateComp.minute = (cal as NSCalendar).range(of: .minute, in: .hour, for: date).length - 1
        dateComp.second = (cal as NSCalendar).range(of: .second, in: .minute, for: date).length - 1
        return cal.date(from: dateComp)!
    }
    
    
    /** get first day of the week - time is set to the first second of the day */
    open class func getFirstDayOfWeek(_ date: Date, locale: Locale) -> Date {
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.locale = locale     // locale needs to be used here, because the first day of week depends on it (e.g. Sunday vs. Monday)
        var dateComp = (cal as NSCalendar).components(Attributes.flags.union(.weekday), from: date)
        dateComp.day = dateComp.day! - dateComp.weekday! + 1 // workaround, because setting directly weekdays is not working
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        return cal.date(from: dateComp)!
    }
    
    
    /** get last day of the week - time is set to the last second of the day */
    open class func getLastDayOfWeek(_ date: Date, locale: Locale) -> Date {
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.locale = locale
        var dateComp = (cal as NSCalendar).components(Attributes.flags.union(.weekday), from: date)
        let weekdayCount = cal.weekdaySymbols.count
        dateComp.day = dateComp.day! + (weekdayCount - dateComp.weekday!) // workaround, because setting directly weekdays is not working
        dateComp.hour = (cal as NSCalendar).range(of: .hour, in: .day, for: date).length - 1
        dateComp.minute = (cal as NSCalendar).range(of: .minute, in: .hour, for: date).length - 1
        dateComp.second = (cal as NSCalendar).range(of: .second, in: .minute, for: date).length - 1
        return cal.date(from: dateComp)!
    }
    
    
    /** Get next weekday counting from the specified date, e.g. get next Friday from today. If today is the specified weekday, it returns today. */
    open class func getWeekday(_ date: Date, weekdayIndex: Int, locale: Locale) -> Date {
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.locale = locale
        
        var dateComp = (cal as NSCalendar).components([.year, .month, .day, .weekday], from: date)
        
        if weekdayIndex >= dateComp.weekday! {
            dateComp.day = dateComp.day! + (weekdayIndex - dateComp.weekday!)
            return cal.date(from: dateComp)!
        } else {
            // next weekday is in the next week
            let weekdayCount = cal.weekdaySymbols.count
            dateComp.day = dateComp.day! - (dateComp.weekday! - weekdayIndex) + weekdayCount
            return cal.date(from: dateComp)!
        }
    }
    
    
    /** get first day of the year - time is set to the first second of the day */
    open class func getFirstDayOfYear(_ year: Int) -> Date {
        let cal = Calendar.current
        var dateComp = DateComponents()
        dateComp.year = year
        dateComp.month = 1
        dateComp.day = 1
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        return cal.date(from: dateComp)!
    }
    
    
    /** get last day of the year - time is set to the last second of the day */
    open class func getLastDayOfYear(_ year: Int) -> Date {
        let cal = Calendar.current
        var dateComp = DateComponents()
        dateComp.year = year
        dateComp.month = (cal as NSCalendar).range(of: .month, in: .year, for: cal.date(from: dateComp)!).length
        dateComp.day = (cal as NSCalendar).range(of: .day, in: .month, for: cal.date(from: dateComp)!).length
        dateComp.hour = (cal as NSCalendar).range(of: .hour, in: .day, for: cal.date(from: dateComp)!).length - 1
        dateComp.minute = (cal as NSCalendar).range(of: .minute, in: .hour, for: cal.date(from: dateComp)!).length - 1
        dateComp.second = (cal as NSCalendar).range(of: .second, in: .minute, for: cal.date(from: dateComp)!).length - 1
        return cal.date(from: dateComp)!
    }

    
    /** get tomorrow - time is set to the first second of the day */
    open class func getTomorrow() -> Date {
        let cal = Calendar.current
        let today = Date()
        var dateComp = (cal as NSCalendar).components(Attributes.flags, from: today)
        dateComp.day = dateComp.day! + 1
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        return cal.date(from: dateComp)!
    }
    
    
    /** Comparing if first date is before second date ignoring time */
    open class func isBeforeDate(_ firstDate: Date, secondDate: Date) -> Bool {
        let firstDateDayBeginning = getBeginningOfDay(firstDate)
        let secondDateDayBeginning = getBeginningOfDay(secondDate)

        let result = firstDateDayBeginning.compare(secondDateDayBeginning)
        if result == .orderedAscending {
            return true
        }
        return false
    }
    
    
    /** Comparing if first date is before second date or it is same date ignoring time */
    open class func isBeforeOrSameDate(_ firstDate: Date, secondDate: Date) -> Bool {
        let firstDateDayBeginning = getBeginningOfDay(firstDate)
        let secondDateDayBeginning = getBeginningOfDay(secondDate)
        
        let result = firstDateDayBeginning.compare(secondDateDayBeginning)
        if result == .orderedAscending || result == .orderedSame {
            return true
        }
        return false
    }
    
    
    /** Comparing if first date is after second date ignoring time */
    open class func isAfterDate(_ firstDate: Date, secondDate: Date) -> Bool {
        let firstDateDayBeginning = getBeginningOfDay(firstDate)
        let secondDateDayBeginning = getBeginningOfDay(secondDate)
        
        let result = firstDateDayBeginning.compare(secondDateDayBeginning)
        if result == .orderedDescending {
            return true
        }
        return false
    }
    
    
    /** Comparing if first date is after second date or it is same date ignoring time */
    open class func isAfterOrSameDate(_ firstDate: Date, secondDate: Date) -> Bool {
        let firstDateDayBeginning = getBeginningOfDay(firstDate)
        let secondDateDayBeginning = getBeginningOfDay(secondDate)
        
        let result = firstDateDayBeginning.compare(secondDateDayBeginning)
        if result == .orderedDescending || result == .orderedSame {
            return true
        }
        return false
    }
    
    
    /** Comparing if first date is same day as second date ignoring time */
    open class func isSameDay(_ firstDate: Date, secondDate: Date) -> Bool {
        let firstDateDayBeginning = getBeginningOfDay(firstDate)
        let secondDateDayBeginning = getBeginningOfDay(secondDate)
        
        let result = firstDateDayBeginning.compare(secondDateDayBeginning)
        if result == .orderedSame {
            return true
        }
        return false
    }
    
    
    /** Comparing if first date is within given month ignoring time */
    open class func isSameMonth(_ firstDate: Date, month: Date) -> Bool {
        let cal = Calendar.current
        let firsDateComp = (cal as NSCalendar).components([.year, .month], from: firstDate)
        let monthDateComp = (cal as NSCalendar).components([.year, .month], from: month)
        return firsDateComp.year == monthDateComp.year && firsDateComp.month == monthDateComp.month
    }
    
    
    /** Returns localized month name for given date */
    open class func getMonthName(_ date: Date, locale: Locale) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let monthIndex = (cal as NSCalendar).components(.month, from: date).month
        return dateFormatter.monthSymbols[monthIndex! - 1] 
    }
    
}
