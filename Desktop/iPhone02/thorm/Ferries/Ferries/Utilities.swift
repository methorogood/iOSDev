//
//  Utilities.swift
//  Ferries
//
//  Created by Mark Thorogood on 6/9/17.
//  Copyright © 2017 Perkins Coie. All rights reserved.
//

import Foundation

class Utilities {
    
    static func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    static func dateAsFormattedString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringOutput = dateFormatter.string(from: date)
        return stringOutput
    }
    
}
