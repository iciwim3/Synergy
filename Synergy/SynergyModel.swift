//
//  SynergyModel.swift
//  Synergy
//
//  Created by Sain-R Edwards on 11/16/18.
//  Copyright © 2018 Swift Koding 4 Everyone. All rights reserved.
//

import Foundation

protocol SynergyProtocol {
    func statementsRetrieved(statements: [Statement])
}

class SynergyModel {
    
    var delegate: SynergyProtocol?
    
    func getStatements() {
        // TODO: Go retrieve data
        
        // When it comes back, call the statementsRetrieved method of the delegate
        delegate?.statementsRetrieved(statements: [Statement]())
    }
    
}
