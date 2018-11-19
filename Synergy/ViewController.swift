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
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var dialogOKButton: UIButton!
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var rootStackView: UIStackView!
    
    // StackView IBOutlet Constraints
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    
    var model = SynergyModel()
    var statements = [Statement]()
    var statementIndex = 0
    var categoryScores = ["Catalyst": 0, "Analyst": 0, "Stabilizer": 0, "Harmonizer": 0]
    
    var resultVC: ResultsViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the Dim View's background color
        dimView.isHidden = false
        
        // Round the corners of the Dialog View and the dialog OK Button
        dialogView.layer.cornerRadius = 10
        dialogOKButton.layer.cornerRadius = 10
        
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
        
        // Animate the question into view
        slideInQuestion()
    }
    
    @IBAction func dialogOKButtonTapped(_ sender: UIButton) {
        dimView.isHidden = true
        dialogView.isHidden = true
        
        // Display the first question
        displayStatement()
    }
    
    func slideInQuestion() {
        
        // Set the starting state
        rootStackView.alpha = 0
        stackViewLeadingConstraint.constant = 1000
        stackViewTrailingConstraint.constant = -1000
        view.layoutIfNeeded()
        
        // Animate the ending state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.rootStackView.alpha = 1
            self.stackViewLeadingConstraint.constant = 0
            self.stackViewTrailingConstraint.constant = 0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func slideOutQuestion() {
        
        // Set the starting state
        rootStackView.alpha = 1
        stackViewLeadingConstraint.constant = 0
        stackViewTrailingConstraint.constant = 0
        view.layoutIfNeeded()
        
        // Animate the ending state
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseIn, animations: {
            
            self.rootStackView.alpha = 0
            self.stackViewLeadingConstraint.constant = -1000
            self.stackViewTrailingConstraint.constant = 1000
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
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
        
        // Slide out question
        slideOutQuestion()
        
        // Display the popup
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
    }
}

// MARK: - ResultViewControllerProtocol methods
extension ViewController: ResultViewControllerProtocol {
    func resultViewDismissed() {

        // If the statement index == question count then we have finished the last question
        if statementIndex == statements.count {
            
            if resultVC != nil {
                // Show summary
                present(resultVC!, animated: true) {
                    self.resultVC?.setPopUp(withTitle: "Summary", forCatalystScore: "total is: \(self.categoryScores["Catalyst"]!)", forAnalystScore: "total is: \(self.categoryScores["Analyst"]!)", forStabilizerScore: "total is: \(self.categoryScores["Stabilizer"]!)", forHarmonizerScore: "total is: \(self.categoryScores["Harmonizer"]!)", withAction: "Restart")
                }
            }
            // Increment the question index so that the next time the user dismisses the dialog, we go into the next branch of IF statement
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

