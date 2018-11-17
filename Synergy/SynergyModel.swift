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
        // Go retrieve data
        getLocalJsonFile()
    }
    
    func getLocalJsonFile() {
        
        // Get a path to the json file in our app bundle
        let path = Bundle.main.path(forResource: "SynergyData", ofType: ".json")
        
        guard path != nil else {
            print("Cannot locate json file!")
            return
        }
        
        // Create a URL object from that string path
        let url = URL(fileURLWithPath: path!)
        
        // Decode that data into instances of the Statement Struct
        do {
            // Get the data from that URL
            let data = try Data(contentsOf: url)
            
            // Decode the json data
            let decoder = JSONDecoder()
            let array = try decoder.decode([Statement].self, from: data)
            
            // Return the question structs to the view controller
            delegate?.statementsRetrieved(statements: array)
        }
        catch {
            print("Could not create Data object from file!")
        }
    }
    
    func getRemoteJsonFile() {
        
    }
    
}
