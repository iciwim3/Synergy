//
//  ResultsViewController.swift
//  Synergy
//
//  Created by Sain-R Edwards on 11/17/18.
//  Copyright © 2018 Swift Koding 4 Everyone. All rights reserved.
//

import UIKit

protocol ResultViewControllerProtocol {
    func resultViewDismissed()
}

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var scoresLabel: UILabel!
    
    // Catalyst Label Outlets
    @IBOutlet weak var catalystScoreLabel: UILabel!
    @IBOutlet weak var catalystLabel: UILabel!
    
    // Analyst Label Outlets
    @IBOutlet weak var analystScoreLabel: UILabel!
    @IBOutlet weak var analystLabel: UILabel!
    
    // Stabilizer Label Outlets
    @IBOutlet weak var stabilizerScoreLabel: UILabel!
    @IBOutlet weak var stabilizerLabel: UILabel!
    
    // Harmonizer Label Outlets
    @IBOutlet weak var harmonizerScoreLabel: UILabel!
    @IBOutlet weak var harmonizerLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    var delegate: ResultViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set rounded corners for Dialog View
        dialogView.layer.cornerRadius = 10
        
        // Set the alpha for the dim view and elements to zero
        scoresLabel.alpha = 0
        dimView.alpha = 0
        
        catalystLabel.alpha = 0
        catalystScoreLabel.alpha = 0
        
        analystLabel.alpha = 0
        analystScoreLabel.alpha = 0
        
        stabilizerLabel.alpha = 0
        stabilizerScoreLabel.alpha = 0
        
        harmonizerLabel.alpha = 0
        harmonizerScoreLabel.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Animate the dim view in
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            
            self.dimView.alpha = 1
            
        }, completion: nil)
    }
    
    func setPopUp(withTitle: String, forCatalystScore: String, forAnalystScore: String, forStabilizerScore: String, forHarmonizerScore: String, withAction: String) {
        
        scoresLabel.text = withTitle
        catalystScoreLabel.text = forCatalystScore
        analystScoreLabel.text = forAnalystScore
        stabilizerScoreLabel.text = forStabilizerScore
        harmonizerScoreLabel.text = forHarmonizerScore
        dismissButton.setTitle(withAction, for: .normal)
        
        // Fade in the labels
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.scoresLabel.alpha = 1
            self.catalystLabel.alpha = 1
            self.catalystScoreLabel.alpha = 1
            self.analystLabel.alpha = 1
            self.analystScoreLabel.alpha = 1
            self.stabilizerLabel.alpha = 1
            self.stabilizerScoreLabel.alpha = 1
            self.harmonizerScoreLabel.alpha = 1
            self.harmonizerLabel.alpha = 1
        }, completion: nil)
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.dimView.alpha = 0
        }) { (completed) in
            
            // Only dismiss after dim view has faded out
            self.dismiss(animated: true, completion: nil)
            self.delegate?.resultViewDismissed()
        }

    }
    
}
