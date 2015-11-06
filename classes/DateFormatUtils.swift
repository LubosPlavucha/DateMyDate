//
//  DateFormatUtils.swift
//  DateMyDate
//
//  Created by lubos plavucha on 26/12/14.
//  Copyright (c) 2014 lubos plavucha. All rights reserved.
//

import Foundation


public class DateFormatUtils {
    
    
    /** Helper struct to load data. Currently only struct can contain static variables in swift language. */
    private struct Load {
        
        /** load date formats - derived from all available locales */
        private static var dateFormatters:[NSLocale:NSDateFormatter] = {
            
            var dateFormatters = [NSLocale:NSDateFormatter]()
            for localeIdentifier in NSLocale.availableLocaleIdentifiers() {
                
                let locale = NSLocale(localeIdentifier: localeIdentifier )
                
                var dateFormatter = NSDateFormatter()
                dateFormatter.locale = locale
                dateFormatter.dateStyle = .ShortStyle
                dateFormatter.timeStyle = .NoStyle
                dateFormatters[locale] = dateFormatter
            }
            return dateFormatters
        }()
        
        private static var datePatterns:[NSLocale: String] = {
            
            var datePatterns = [NSLocale: String]()
            for (locale, dateFormatter) in dateFormatters {
                datePatterns[locale] = dateFormatter.dateFormat
            }
            return datePatterns
        }()
    }
    
   
    /** Returns dictionary of locales and corresponding date formatters. */
    public class func getDateFormatters(locales: [NSLocale]) -> [NSLocale:NSDateFormatter] {
        var result = [NSLocale:NSDateFormatter]()
        for (locale, dateFormatter) in Load.dateFormatters {
            if locales.contains(locale) {
                result[locale] = dateFormatter
            }
        }
        return result
    }
    
    
    /** Returns dictionary of locales and corresponding date patterns. */
    public class func getDatePatterns(locales: [NSLocale]) -> [NSLocale:String] {
        var result = [NSLocale:String]()
        for (locale, datePattern) in Load.datePatterns {
            if locales.contains(locale) {
                result[locale] = datePattern
            }
        }
        return result
    }
    
   
    /** Returns date patterns from all available locals. */
    public class func getDatePatterns() -> [String] {
        let result = NSMutableSet() // use Set to make the array unique
        result.addObjectsFromArray(Array(Load.datePatterns.values))
        return result.allObjects as! [String]
    }
    
}
