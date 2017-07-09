//
//  Extensions.swift
//  BaseProject
//
//  Created by alişan dağdelen on 9.07.2017.
//  Copyright © 2017 alisandagdeleb. All rights reserved.
//

import Foundation


public extension Date {
    
    public func formattedString(_ format:String, timeZone:TimeZone! = TimeZone(identifier:"UTC")) -> String {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = timeZone
        dateFormat.dateFormat = format
        let str = dateFormat.string(from:self)
        return str
    }
    
    public func serverString(_ timeZone:TimeZone! = TimeZone(identifier:"UTC")) -> String {
        return formattedString("yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'", timeZone:timeZone) as String
    }
    
    
    
    public static func dateFromServerString(_ dateStr:String, timeZone:TimeZone! = TimeZone(identifier:"UTC")) -> Date? {
        var date = Date.dateFromDisplayString("yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'", dateString:dateStr, timeZone:timeZone)
        if date == nil {
            date = Date.dateFromDisplayString("yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'", dateString:dateStr, timeZone:timeZone)
        }
        return date
    }
    
    public static func dateFromDisplayString (_ format: String, dateString:String?, timeZone:TimeZone! = TimeZone(identifier:"UTC")) -> Date? { //! = NSTimeZone(name:"UTC")
        if dateString == nil {
            return nil
        }
        
        let dateFormat = DateFormatter()
        dateFormat.timeZone = timeZone
        dateFormat.dateFormat = format
        let date = dateFormat.date(from: dateString!)
        return date
    }
}
