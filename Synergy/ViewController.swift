//
//  ViewController.swift
//  Synergy
//
//  Created by Sain-R Edwards on 11/16/18.
//  Copyright © 2018 Swift Koding 4 Everyone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var model = SynergyModel()
    var statement = [Statement]()
    var statementIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        model.getStatements()
    }


}

// MARK: - SynergyProtocol methods

extension ViewController: SynergyProtocol {
    func statementsRetrieved(statements: [Statement]) {
        print("Looks like it is working bro!")
    }
}

