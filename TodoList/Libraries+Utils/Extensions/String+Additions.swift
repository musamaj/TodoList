//
//  String+Additions.swift
//  FanTazTech
//
//  Created by Muhammad Azher on 15/01/2018.
//  Copyright © 2018 Expertinsol. All rights reserved.
//


import Foundation

extension String {
    var length: Int { return count}
    
    mutating func removeFirstCharacter() -> Character {
        return remove(at: startIndex)
    }
    
    func characterAtIndex(_ index: Int) -> Character {
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    mutating func insertCharacter(_ character: Character, atIndex index: Int) -> () {
        
        guard index < length else { return }
        
        insert(character, at: self.index(startIndex, offsetBy: 4))
    }
    
    func dateFromString(_ pattern:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pattern
        return dateFormatter.date(from: self)
    }
    
    func isValidEmail() -> Bool
    {
        let EMAIL_REGEX = "^([^@\\s]+)@((?:[-a-z0-9]+\\.)+[a-z]{2,})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX)
        return predicate.evaluate(with: self)
    }
    
    var toPhoneNumberFormatted: String {
        get {
//            let numberString = "+" + self
//            let number = try? PhoneNumberKit().parse(numberString).numberString
//            return number ?? self
            return toPhoneNumberFormattedWithoutPhoneKit
        }
    }
    var toPhoneNumberFormattedWithoutPhoneKit: String {
        get {
            return "+" + self
        }
    }
    
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}


extension String {
    func isEmptyOrWhitespace() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
    
    func initials()-> String {
        return String(self.prefix(1)).capitalized
        
    }
}
