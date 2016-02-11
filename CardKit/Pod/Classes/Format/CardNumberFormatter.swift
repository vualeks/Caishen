//
//  CardNumberFormatter.swift
//  Pods
//
//  Created by Daniel Vancura on 2/4/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
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
     Formats the given card number string based on the detected card type.
     - seealso: CardType.CardTypeForNumber
     - seealso: CardType.numberGroupingForCardType
     - parameter cardNumberString: The card number's unformatted string representation.
     - returns: Formatted card number string.
     */
    public func formattedCardNumber(cardNumberString: String) -> String {
        let regex: NSRegularExpression
        
        let cardType = CardType.CardTypeForNumber(CardNumber(string: cardNumberString))
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
     Computes the index of the cursor position after unformatting the textField's content.
     - parameter textField: The textField containing a formatted string.
     - returns: The index of the cursor position or nil, if no selected text was found.
     */
    public func cursorPositionAfterUnformattingText(text: String, inTextField textField: UITextField) -> Int? {
        guard let selectedRange = textField.selectedTextRange else {
            return nil
        }
        let addedCharacters = text.length() - (textField.text ?? "").length()
        
        let position = textField.offsetFromPosition(textField.beginningOfDocument, toPosition: selectedRange.start) + addedCharacters
        
        let formattedString = text ?? ""
        let components = formattedString.componentsSeparatedByString(self.separator)
        
        // Find the component that contains the cursor
        var componentContainingCursor = 0
        var stringParsingIndex = 0
        for i in 0..<components.count {
            stringParsingIndex += components[i].length()
            if position <= stringParsingIndex {
                componentContainingCursor = i
                break
            }
            stringParsingIndex += self.separator.length()
        }
        
        return position - componentContainingCursor * self.separator.length()
    }
    
    public func cursorPositionAfterFormattingText(text: String, inTextField textField: UITextField) -> Int? {
        guard let selectedRange = textField.selectedTextRange else {
            return nil
        }
        let addedCharacters = self.formattedCardNumber(text).length() - (textField.text ?? "").length()
        
        let position = textField.offsetFromPosition(textField.beginningOfDocument, toPosition: selectedRange.start) + addedCharacters
        
        let formattedString = self.formattedCardNumber(text)
        let components = formattedString.componentsSeparatedByString(self.separator)
        
        // Find the component that contains the cursor
        var componentContainingCursor = 0
        var stringParsingIndex = 0
        for i in 0..<components.count {
            stringParsingIndex += components[i].length()
            if position <= stringParsingIndex {
                componentContainingCursor = i
                break
            }
            stringParsingIndex += self.separator.length()
        }
        
        return position + componentContainingCursor * self.separator.length()
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
