//
//  DateFormatter.swift
//  Github_user_ios
//
//  Created by Navdeep on 23/07/2023.
//

import Foundation
import UIKit

class DateFormatterExplicit{
    
    class func formatedDate(_ dateString:String,_from fromDateString:String? = nil) -> String{
        
        let formatter = ISO8601DateFormatter()//because date is in ISO8601Date format
        
        if let date = formatter.date(from: dateString){
            var currentDate:Date
            if(fromDateString == nil){
                currentDate = Date()
            }
            else{
                currentDate = formatter.date(from: fromDateString!)!
            }
            let calandar = Calendar.current
            
            if let years = calandar.dateComponents([.year], from: date, to: currentDate).year, years > 0 {
                if years > 1 {
                    return "\(years) years ago"
                }
                return "\(years) year ago"
            }
            
            if let months = calandar.dateComponents([.month], from: date, to: currentDate).month, months > 0 {
                if months > 1 {
                    return "\(months) months ago"
                }
                return "\(months) month ago"
            }
            
            if let weeks = calandar.dateComponents([.weekOfMonth], from: date, to: currentDate).weekOfMonth, weeks > 0 {
                if weeks > 1 {
                    return "\(weeks) weeks ago"
                }
                return "\(weeks) week ago"
            }
            
            if let days = calandar.dateComponents([.day], from: date, to: currentDate).day, days > 0 {
                if days > 1 {
                    return "\(days) days ago"
                }
                return "\(days) day ago"
            }
            
            if let hours = calandar.dateComponents([.hour], from: date, to: currentDate).hour, hours > 0 {
                if hours > 1 {
                    return "\(hours) hours ago"
                }
                return "\(hours) hour ago"
            }
            
            if let minutes = calandar.dateComponents([.minute], from: date, to: currentDate).minute, minutes > 0 {
                if minutes > 1 {
                    return "\(minutes) mins ago"
                }
                return "\(minutes) min ago"
            }
            
            if let secs = calandar.dateComponents([.second], from: date, to: currentDate).second, secs > 0 {
                if secs > 1 {
                    return "\(secs) secs ago"
                }
                return "\(secs) sec ago"
            }
            
        }
        return "Just Now"
        
    }

}
