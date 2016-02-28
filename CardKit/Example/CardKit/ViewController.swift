//
//  ViewController.swift
//  CardKit
//
//  Created by Daniel Vancura on 02/03/2016.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit
import CardKit

class ViewController: UIViewController, CardNumberTextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIButton?
    @IBOutlet weak var cardNumberTextField0: CardNumberTextField!
    @IBOutlet weak var cardNumberTextField1: CardNumberTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton?.enabled = false
        
        [cardNumberTextField0, cardNumberTextField1].forEach({$0.cardNumberTextFieldDelegate = self})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cardNumberTextField(cardNumberTextField: CardNumberTextField, didEnterCardInformation information: Card?, withValidationResult validationResult: CardValidationResult?) {
        if information == nil {
            saveButton?.enabled = false
        } else {
            saveButton?.enabled = true
        }
    }

}

