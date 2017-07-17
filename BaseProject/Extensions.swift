//
//  Extensions.swift
//  BaseProject
//
//  Created by alişan dağdelen on 9.07.2017.
//  Copyright © 2017 alisandagdeleb. All rights reserved.
//

import UIKit


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
    
    public static func dateFromDisplayString (_ format: String, dateString:String?, timeZone:TimeZone! = TimeZone(identifier:"UTC")) -> Date? {
        
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

extension String {
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    func toDictionary() -> [String: Any]? {
        if let data = data(using:.utf8) {
            do {
                return try JSONSerialization.jsonObject(with:data, options:[]) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func toDate()->Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: self)
    }
}

extension Double {
    
    func percentageRepresentation() -> String {
        
        if floor(self) == self {
            return "%\(Int(self))"
        }
        return "%\(self)"
    }
}

extension UITextField {
    func isNumericInput(shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if self.keyboardType == UIKeyboardType.numberPad || self.keyboardType == UIKeyboardType.decimalPad {
            let nonNumericInput = CharacterSet(charactersIn: "0123456789.-").inverted
            if let _ = string.rangeOfCharacter(from: nonNumericInput) {
                return false
            }
        }
        return true
    }
}
