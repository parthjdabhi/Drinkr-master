//
//  Extensions.swift
//  Drinkr
//
//  Created by Dustin Allen on 10/5/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import UIKit


extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.sharedApplication()
        for url in urls {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }
}

extension UIImage {
        func imgToBase64() -> String {
            let imageData:NSData = UIImageJPEGRepresentation(self, 0.8)!
            let base64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            print(base64String)
            
            return base64String
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension NSDate {
    func daysOfTheWeek() -> Array<String> {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Satudrday,"
        ]
        
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let components: NSDateComponents = calendar.components(.Weekday, fromDate: self)
        var Days:Array<String> = []
        Days.append("Today")
        Days.appendContentsOf(weekdays.suffixFrom(components.weekday))
        if components.weekday > 0 {
            Days.appendContentsOf(weekdays.prefixUpTo(components.weekday - 1))
        }
        print("daysOfTheWeek Days : \(Days)")
        return Days
        //return weekdays[components.weekday - 1]
    }
}