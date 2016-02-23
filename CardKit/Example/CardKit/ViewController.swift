//
//  ViewController.swift
//  CardKit
//
//  Created by Daniel Vancura on 02/03/2016.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit
import CardKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(CardNumberTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 30)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

