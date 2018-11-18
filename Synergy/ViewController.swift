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
    
    var resultVC: ResultsViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup result dialog view controller
        resultVC = storyboard?.instantiateViewController(withIdentifier: "ResultVC") as? ResultsViewController
        resultVC?.delegate = self
        resultVC?.modalPresentationStyle = .overCurrentContext
        
        // Conform to tableview protocols
        statementTableView.delegate = self
        statementTableView.dataSource = self
        
        // Configure the tableview for dynamic row height
        statementTableView.estimatedRowHeight = 50
        statementTableView.rowHeight = UITableView.automaticDimension
        
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
        
        // Set the text for label
        label.text = String(statements[statementIndex].answers![indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Check against statement index being out of bounds
        guard statementIndex < statements.count else {
            return
        }
        
        // Declare variables for the popup
        let title = "Scores"
        let action: String = "Next"
        
        // User has selected an answer
        let categoryIndex = statements[statementIndex].categoryIndex
        
        switch categoryIndex {
        case 0:
            if var catalyst = categoryScores["Catalyst"] {
                catalyst += indexPath.row + 1
                categoryScores["Catalyst"] = catalyst
            }
            
        case 1:
            if var analyst = categoryScores["Analyst"] {
                analyst += indexPath.row + 1
                categoryScores["Analyst"] = analyst
            }
            
        case 2:
            if var stabilizer = categoryScores["Stabilizer"] {
                stabilizer += indexPath.row + 1
                categoryScores["Stabilizer"] = stabilizer
            }
            
        case 3:
            if var harmonizer = categoryScores["Harmonizer"] {
                harmonizer += indexPath.row + 1
                categoryScores["Harmonizer"] = harmonizer
            }
            
        default:
            print("Select something!")
        }
       
        if resultVC != nil {
            
            present(resultVC!, animated: true) {
                // Set the message for the popup
                self.resultVC?.setPopUp(withTitle: title, forCatalystScore: "\(self.categoryScores["Catalyst"]!)", forAnalystScore: "\(self.categoryScores["Analyst"]!)", forStabilizerScore: "\(self.categoryScores["Stabilizer"]!)", forHarmonizerScore: "\(self.categoryScores["Harmonizer"]!)", withAction: action)
            }
        }
        
        // Increment statement index to advance to next question
        statementIndex += 1
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

// MARK: - ResultViewControllerProtocol methods
extension ViewController: ResultViewControllerProtocol {
    func resultViewDismissed() {
        
        // Check the statement index
        
        
        // If the statement index == question count then we have finished the last question
        if statementIndex == statements.count {
            
            if resultVC != nil {
                // Show summary
                present(resultVC!, animated: true) {
                    self.resultVC?.setPopUp(withTitle: "Summary", forCatalystScore: "Catalyst total: \(self.categoryScores["Catalyst"]!)", forAnalystScore: "Analyst total: \(self.categoryScores["Analyst"]!)", forStabilizerScore: "Stabilizer total: \(self.categoryScores["Stabilizer"]!)", forHarmonizerScore: "Harmonizer total: \(self.categoryScores["Harmonizer"]!)", withAction: "Restart")
                }
            }
            statementIndex += 1
        }
        else if statementIndex > statements.count {
            
            // Restart assessment
            categoryScores["Catalyst"] = 0
            categoryScores["Analyst"] = 0
            categoryScores["Stabilizer"] = 0
            categoryScores["Harmonizer"] = 0
            statementIndex = 0
            displayStatement()
            
        }
        else {
            // Display next question when Result VC has been dismissed
            displayStatement()
        }
    }
}

