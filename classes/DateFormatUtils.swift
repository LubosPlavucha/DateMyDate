//
//  DateFormatUtils.swift
//  DateMyDate
//
//  Created by lubos plavucha on 26/12/14.
//  Copyright (c) 2014 lubos plavucha. All rights reserved.
//

import Foundation


open class DateFormatUtils {
    
    
    /** Helper struct to load data. Currently only struct can contain static variables in swift language. */
    fileprivate struct Load {
        
        /** load date formats - derived from all available locales */
        fileprivate static var dateFormatters:[Locale:DateFormatter] = {
            
            var dateFormatters = [Locale:DateFormatter]()
            for localeIdentifier in Locale.availableIdentifiers {
                
                let locale = Locale(identifier: localeIdentifier )
                
                var dateFormatter = DateFormatter()
                dateFormatter.locale = locale
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .none
                dateFormatters[locale] = dateFormatter
            }
            return dateFormatters
        }()
        
        fileprivate static var datePatterns:[Locale: String] = {
            
            var datePatterns = [Locale: String]()
            for (locale, dateFormatter) in dateFormatters {
                datePatterns[locale] = dateFormatter.dateFormat
            }
            return datePatterns
        }()
    }
    
   
    /** Returns dictionary of locales and corresponding date formatters. */
    open class func getDateFormatters(_ locales: [Locale]) -> [Locale:DateFormatter] {
        var result = [Locale:DateFormatter]()
        for (locale, dateFormatter) in Load.dateFormatters {
            if locales.contains(locale) {
                result[locale] = dateFormatter
            }
        }
        return result
    }
    
    
    /** Returns dictionary of locales and corresponding date patterns. */
    open class func getDatePatterns(_ locales: [Locale]) -> [Locale:String] {
        var result = [Locale:String]()
        for (locale, datePattern) in Load.datePatterns {
            if locales.contains(locale) {
                result[locale] = datePattern
            }
        }
        return result
    }
    
   
    /** Returns date patterns from all available locals. */
    open class func getDatePatterns() -> [String] {
        let result = NSMutableSet() // use Set to make the array unique
        result.addObjects(from: Array(Load.datePatterns.values))
        return result.allObjects as! [String]
    }
    
}
