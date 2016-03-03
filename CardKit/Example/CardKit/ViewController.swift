//
//  ViewController.swift
//  CardKit
//
//  Created by Daniel Vancura on 02/03/2016.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit
import CardKit

class ViewController: UIViewController, CardNumberTextFieldDelegate, CardIOPaymentViewControllerDelegate {
    
    @IBOutlet weak var saveButton: UIButton?
    @IBOutlet weak var cardNumberTextField: CardNumberTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton?.enabled = false
        
        // Assign self as the delegate for both card number text fields.
        cardNumberTextField.cardNumberTextFieldDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This method of `CardNumberTextFieldDelegate` will set the saveButton enabled or disabled, based on whether valid card information has been entered.
    func cardNumberTextField(cardNumberTextField: CardNumberTextField, didEnterCardInformation information: Card?, withValidationResult validationResult: CardValidationResult?) {
        if validationResult != .Valid {
            saveButton?.enabled = false
        } else {
            saveButton?.enabled = true
        }
    }
    
    func cardNumberTextFieldShouldShowAccessoryImage(cardNumberTextField: CardNumberTextField) -> UIImage? {
        return UIImage()
    }
    
    func cardNumberTextFieldShouldShowAccessoryTitle(cardNumberTextField: CardNumberTextField) -> String? {
        return "CardIO"
    }
    
    func cardNumberTextFieldShouldProvideAccessoryAction(cardNumberTextField: CardNumberTextField) -> (() -> ())? {
        return { [weak self] _ in
            let cardIOViewController = CardIOPaymentViewController(paymentDelegate: self)
            self?.presentViewController(cardIOViewController, animated: true, completion: nil)
        }
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        cardNumberTextField.prefillCardInformation(cardInfo.cardNumber, month: Int(cardInfo.expiryMonth), year: Int(cardInfo.expiryYear), cvc: cardInfo.cvv)
    }

}

