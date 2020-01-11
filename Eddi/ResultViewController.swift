//
//  ResultViewController.swift
//  Eddi
//
//  Created by Kurt Höblinger on 11.01.20.
//  Copyright © 2020 Kurt Höblinger. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    var extTrain: String = "000"
    var intTrain: String = "000"
    var unTrain: String = "000"
    
    var hfTrain1: String = "000 - 000"
    var hfTrain2: String = "000 - 000"
    var hfTrain3: String = "000 - 000"
    var hfTrain4: String = "000 - 000"
    var hfTrain5: String = "000 - 000"
    
    var trainLabelState: Int = 0
    
    @IBOutlet weak var karvonenL: UILabel!
    @IBOutlet weak var trainTypeLabel: UILabel!
    @IBOutlet weak var hfTrain1L: UILabel!
    @IBOutlet weak var hfTrain2L: UILabel!
    @IBOutlet weak var hfTrain3L: UILabel!
    @IBOutlet weak var hfTrain4L: UILabel!
    @IBOutlet weak var hfTrain5L: UILabel!
    
    @IBAction func buttonRight(_ sender: Any) {
        circleRight()
    }
    @IBAction func buttonLeft(_ sender: Any) {
        circleLeft()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        karvonenL.text = extTrain
        hfTrain1L.text = hfTrain1
        hfTrain2L.text = hfTrain2
        hfTrain3L.text = hfTrain3
        hfTrain4L.text = hfTrain4
        hfTrain5L.text = hfTrain5
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        print ("left")
        circleLeft()
    }
    
    func circleLeft() -> Void {
        if trainLabelState == 0 {
            trainLabelState = 1
            trainTypeLabel.text = "intensives Ausdauertraining"
            karvonenL.text = intTrain
        } else if trainLabelState == 1 {
            trainLabelState = 2
            trainTypeLabel.text = "untrainiert"
            karvonenL.text = unTrain
        } else {
            trainLabelState = 0
            trainTypeLabel.text = "extensives Ausdauertraining"
            karvonenL.text = extTrain
        }
    }
    
    func circleRight() -> Void {
        if trainLabelState == 0 {
            trainLabelState = 2
            trainTypeLabel.text = "untrainiert"
            karvonenL.text = unTrain
        } else if trainLabelState == 1 {
            trainLabelState = 0
            trainTypeLabel.text = "extensives Ausdauertraining"
            karvonenL.text = extTrain
        } else {
            trainLabelState = 1
            trainTypeLabel.text = "intensives Ausdauertraining"
            karvonenL.text = intTrain
        }
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        print("right")
        circleRight()
    }
}
