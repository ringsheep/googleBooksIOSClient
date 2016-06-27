//
//  CalendarUtils.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/26/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import Foundation

class CalendarUtils
{
    class func dateFromString( date : String ) -> NSDate?
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var finalizedDate = date
        
        switch finalizedDate.characters.count {
        case 4:
            finalizedDate += "-01-01"
        case 7:
            finalizedDate += "-01"
        default:
            return nil
        }

        return dateFormatter.dateFromString("\(finalizedDate) 00:00:00")!
    }
}