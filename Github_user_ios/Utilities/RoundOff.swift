//
//  RoundOff.swift
//  Github_user_ios
//
//  Created by Navdeep on 24/07/2023.
//

import Foundation

class RoundOff {
    class func roundoff(_ value: Int) -> String {
        if value >= 1000000 {
            let formatted = Double(value) / 1000000
            return String(format:"%.1fM", formatted)
        } else if value >= 1000 {
            let formatted = Double(value) / 1000
            return String(format:"%.1fK", formatted)
        }
        return "\(value)"
    }
}
