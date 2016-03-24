//
//  ViewController.swift
//  Caishen
//
//  Created by Daniel Vancura on 02/03/2016.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit
import Caishen

class ViewController: UIViewController, CardNumberTextFieldDelegate, CardIOPaymentViewControllerDelegate {
    
    @IBOutlet weak var buyButton: UIButton?
    @IBOutlet weak var cardNumberTextField: CardNumberTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardNumberTextField.cardNumberTextFieldDelegate = self
    }
    
    @IBAction func buy(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - CardNumberTextField delegate methods
    
    // This method of `CardNumberTextFieldDelegate` will set the saveButton enabled or disabled, based on whether valid card information has been entered.
    func cardNumberTextField(cardNumberTextField: CardNumberTextField, didEnterCardInformation information: Card, withValidationResult validationResult: CardValidationResult) {

        print (validationResult)

        buyButton?.enabled = validationResult == .Valid
    }
    
    func cardNumberTextFieldShouldShowAccessoryImage(cardNumberTextField: CardNumberTextField) -> UIImage? {
        return UIImage(named: "camera")
    }
    
    func cardNumberTextFieldShouldProvideAccessoryAction(cardNumberTextField: CardNumberTextField) -> (() -> ())? {
        return { [weak self] _ in
            let cardIOViewController = CardIOPaymentViewController(paymentDelegate: self)
            self?.presentViewController(cardIOViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Card.io delegate methods
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        cardNumberTextField.prefillCardInformation(cardInfo.cardNumber, month: Int(cardInfo.expiryMonth), year: Int(cardInfo.expiryYear), cvc: cardInfo.cvv)
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}

