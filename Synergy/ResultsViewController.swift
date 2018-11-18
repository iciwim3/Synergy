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
    @IBOutlet weak var catalystScoreLabel: UILabel!
    @IBOutlet weak var analystScoreLabel: UILabel!
    @IBOutlet weak var stabilizerScoreLabel: UILabel!
    @IBOutlet weak var harmonizerScoreLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var delegate: ResultViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set rounded corners for Dialog View
        dialogView.layer.cornerRadius = 10
        
    }
    
    func setPopUp(withTitle: String, forCatalystScore: String, forAnalystScore: String, forStabilizerScore: String, forHarmonizerScore: String, withAction: String) {
        
        scoresLabel.text = withTitle
        catalystScoreLabel.text = forCatalystScore
        analystScoreLabel.text = forAnalystScore
        stabilizerScoreLabel.text = forStabilizerScore
        harmonizerScoreLabel.text = forHarmonizerScore
        dismissButton.setTitle(withAction, for: .normal)
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        delegate?.resultViewDismissed()
        
    }
    
}
