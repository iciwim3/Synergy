//
//  FirstViewController.swift
//  Synergy
//
//  Created by Sain-R Edwards on 11/18/18.
//  Copyright © 2018 Swift Koding 4 Everyone. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var startAssessmentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startAssessmentButton.layer.cornerRadius = 10
        
    }
    
    @IBAction func startAssessmentButtonTapped(_ sender: UIButton) {
        
    }

}
