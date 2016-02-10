//
//  CardNumberFormatter.swift
//  Pods
//
//  Created by Daniel Vancura on 2/4/16.
//
//

import UIKit

public class CardNumberFormatter: NSObject {
    public var separator: String
    
    /**
     Creates a `CardNumberFormatter` with the provided separator for formatting.
     - parameter separator: The separator that is used for grouping the card number.
     */
    public init(separator: String) {
        self.separator = separator
    }
    
    /**
     Creates a default `CardNumberFormatter` with a single space as separator for formatting.
     */
    public convenience override init() {
        self.init(separator: " ")
    }
    
    /**
     This function removes the format of a card number string that has been formatted with the same instance of a `CardNumberFormatter`.
     - parameter cardNumberString: The card number string representation that has previously been formatted with `self`.
     - returns: The unformatted card number string representation.
     */
    public func unformattedCardNumber(cardNumberString: String) -> String {
        return cardNumberString.stringByReplacingOccurrencesOfString(self.separator, withString: "")
    }
    
    /**
     Formats the given card number string based on the card type.
     - parameter cardNumberString: The card number's unformatted string representation.
     - parameter cardType: The card type for which the card number is supposed to be formatted.
     - returns: Formatted card number string.
     */
    public func formattedCardNumber(cardNumberString: String, forCardType cardType: CardType) -> String {
        let regex: NSRegularExpression
        do {
            let groups = CardType.numberGroupingForCardType(cardType)
            var pattern = ""
            var first = true
            for group in groups {
                pattern += "(\\d{1,\(group)})"
                if !first {
                    pattern += "?"
                }
                first = false
            }
            regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions())
        } catch {
            fatalError("Error when creating regular expression: \(error)")
        }
        
        return NSArray(array: self.splitString(cardNumberString, withRegex: regex)).componentsJoinedByString(self.separator)
    }
    
    /**
     Splits a string with a given regular expression and returns all matches in an array of separate strings.
     - parameter string: The string that is to be split.
     - parameter regex: The regular expression that is used to search for matches in `string`.
     - returns: An array of all matches found in string for `regex`.
     */
    private func splitString(string: String, withRegex regex: NSRegularExpression) -> [String] {
        let matches = regex.matchesInString(string, options: NSMatchingOptions(), range: NSMakeRange(0, string.length()))
        var result = [String]()
        
        matches.forEach {
            for i in 1..<$0.numberOfRanges {
                let range = $0.rangeAtIndex(i)
                
                if range.length > 0 {
                    result.append(NSString(string: string).substringWithRange(range))
                }
            }
        }
        
        return result
    }
}
