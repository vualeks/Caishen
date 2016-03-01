//
//  CardFactory.swift
//  Pods
//
//  Created by Daniel Vancura on 2/3/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

public enum CardCreationError: ErrorType {

    case InvalidDateFormat
    case CardValidationFailed(validationResult: CardValidationResult)

}
