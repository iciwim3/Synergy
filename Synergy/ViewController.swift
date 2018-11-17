//
//  ViewController.swift
//  Synergy
//
//  Created by Sain-R Edwards on 11/16/18.
//  Copyright © 2018 Swift Koding 4 Everyone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var statementLabel: UILabel!
    @IBOutlet weak var statementTableView: UITableView!
    
    var model = SynergyModel()
    var statements = [Statement]()
    var statementIndex = 0
    var selectedAnswer = 0
    var categoryScores = ["Catalyst": 0, "Analyst": 0, "Stabilizer": 0, "Harmonizer": 0]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Conform to tableview protocols
        statementTableView.delegate = self
        statementTableView.dataSource = self
        
        // Set self as delegate for model and call getStatements
        model.delegate = self
        model.getStatements()
    }
    
    func displayStatement() {
        
        // Check that the current statement index is not beyond bounds of statement array
        guard statementIndex < statements.count else {
            print("Trying to display a statement index that is out of bounds!")
            return
        }
        
        // Display the statement
        statementLabel.text = statements[statementIndex].statement!
        
        // Display the answers
        statementTableView.reloadData() // This asks the tableview for the number of rows in section and cellForRowAt index path
    }

}

// MARK: - TableView Protocol methods
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard statements.count > 0 && statements[statementIndex].answers != nil else {
            return 0
        }
        return statements[statementIndex].answers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        // Get the label
        let label = cell.viewWithTag(1) as! UILabel
        
        // TODO: Set the text for label
        label.text = String(statements[statementIndex].answers![indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // User has selected an answer
        let categoryIndex = statements[statementIndex].categoryIndex
        
        switch categoryIndex {
        case 0:
            categoryScores["Catalyst"]! += 1
            print("Category score is: \()")
            return
        case 1:
            categoryScores["Analyst"]! += 1
            return
        case 2:
            categoryScores["Stabilizer"]! += 1
            return
        case 3:
            categoryScores["Harmonizer"]! += 1
            return
        default:
            print("Select something!")
        }
    }

}

// MARK: - SynergyProtocol methods
extension ViewController: SynergyProtocol {
    func statementsRetrieved(statements: [Statement]) {
        
        // Set our questions property with the questions from quiz model
        self.statements = statements
        
        // Display the first question
        displayStatement()
    }
}

