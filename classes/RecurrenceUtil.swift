
import Foundation
import EventKit


public class RecurrenceUtil {
    
    
    public enum Frequency {
        case DAILY, WEEKLY, MONTHLY
    }

    
    /** Generates dates from recurrence pattern. If no end date is specified, it generates the dates for 2 years in future. Weekdays are indexed between 1 to 7 based on the indexing from the NSDateComponents.weekdays. */
    public class func generateDatesFromRecurrence(frequency: Frequency, interval: Int, daysOfWeek:[Int]? = nil, locale: NSLocale? = nil, beginDate: NSDate, var endDate: NSDate?) -> [NSDate] {
        
        var dates:[NSDate] = []
        
        let add1Year = DateUtil.addYears(beginDate, yearCount: 1)
        if let endDateTmp = endDate {
            // if end date is before begin date -> return empty
            if DateUtil.isBeforeDate(endDateTmp, secondDate: beginDate) {
                return dates
            }
            // if end date is more than 2 years in future from begin date, set limit to 1 year
            if DateUtil.isAfterDate(endDateTmp, secondDate: add1Year) {
                endDate = add1Year
            }
        } else {
            // if end date not specified -> set limit to 1 year
            endDate = add1Year
        }
        
        var date = beginDate
        
        switch frequency {
            
            case .DAILY:
            
                while(DateUtil.isBeforeOrSameDate(date, secondDate: endDate!)) {
                    dates.append(date)
                    date = DateUtil.addDays(date, daysCount: interval)
                }
            
            
            case .WEEKLY:
                
                assert(daysOfWeek != nil && !daysOfWeek!.isEmpty && locale != nil)
                // first get the first date according to the weekday -> this doesn't have to correspond to the begin date - e.g. begin data can be on Monday, but only Sundays are included in the weekday recurrence (which is in US calendar already the next week) -> first date in the computation needs to be set to Sunday
 
                // sort weekday indexes, since it is not guaranteed
                let sortedDaysOfWeek = NSMutableArray(array: daysOfWeek!)
                sortedDaysOfWeek.sortUsingSelector(Selector("compare:"))
                
                var firstWeekday = DateUtil.getWeekday(date, weekdayIndex: sortedDaysOfWeek.firstObject as! Int, locale: locale!)
                
                var loop = true
                while(loop) {
                    
                    for weekdayIndex in sortedDaysOfWeek {
                        if DateUtil.isBeforeOrSameDate(date, secondDate: endDate!) {
                            date = DateUtil.getWeekday(date, weekdayIndex: weekdayIndex as! Int, locale: locale!)
                            dates.append(date)
                        } else {
                            loop = false
                        }
                    }
                    firstWeekday = DateUtil.addWeeks(firstWeekday, weeksCount: interval)
                    date = firstWeekday
                }
            
            case .MONTHLY:
            
                // INFO: currently only 1 day in month is considered - the first one is begin date
                while(DateUtil.isBeforeOrSameDate(date, secondDate: endDate!)) {
                    dates.append(date)
                    date = DateUtil.addMonths(date, monthsCount: interval)
                }
        }
        return dates
    }

}