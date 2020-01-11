//
//  ViewController.swift
//  Eddi
//
//  Created by Kurt Höblinger on 11.01.20.
//  Copyright © 2020 Kurt Höblinger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let numbers = [
        "",
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9"
    ]
    
    @IBOutlet weak var agePicker: UIPickerView!
    @IBOutlet weak var hfminpicker: UIPickerView!
    @IBOutlet var overallView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.agePicker.delegate = self
        self.agePicker.dataSource = self
        
        self.agePicker.selectRow(3, inComponent: 0, animated: false)
        self.agePicker.selectRow(9, inComponent: 1, animated: false)
        
        let ageLabel = UILabel()
        ageLabel.text = "Jahre"
        
        self.agePicker.setPickerLabels(labels: [1: ageLabel], containedView: overallView)
        
        self.hfminpicker.delegate = self
        self.hfminpicker.dataSource = self
        
        self.hfminpicker.selectRow(6, inComponent: 1, animated: false)
        self.hfminpicker.selectRow(4, inComponent: 2, animated: false)
        
        let hfminLabel = UILabel()
        hfminLabel.text = "Schläge"
        
        hfminpicker.setPickerLabels(labels: [2: hfminLabel], containedView: overallView)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 11
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print(pickerView.tag)
        if (pickerView.tag == 0) {
            return 2
        } else {
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numbers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 25.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "results") {
            
            let age = Double(String(numbers[agePicker.selectedRow(inComponent: 0)]) + String(numbers[agePicker.selectedRow(inComponent: 1)]))!
            let hfmin = Double(String(numbers[hfminpicker.selectedRow(inComponent: 0)]) + String(numbers[hfminpicker.selectedRow(inComponent: 1)]) + String(numbers[hfminpicker.selectedRow(inComponent: 2)]))!
            let hfmax = 220.0 - age
            let hfres = hfmax - hfmin
            let hfTrainE = String(Int(hfres * 0.8 + hfmin))
            let hfTrainI = String(Int(hfres * 0.6 + hfmin))
            let hfTrainU = String(Int(hfres * 0.5 + hfmin))
            // THF = RHF + (HFR x Faktor)
            /*
             1 - Gesundheitszone: 50 bis 60 % der maximalen Herzfrequenz (HFmax) (Faktor 0,5 bis 0,6)
             2 - Fettstoffwechselzone: 60 bis 70 % der HFmax (Faktor 0,6 bis 0,7)
             3 - Aerobe Zone: 70 bis 80 % der HFmax (Faktor 0,7 bis 0,8)
             4 - Anaerobe Zone: 80 bis 90 % der HFmax (Faktor 0,8 bis 0,9)
             5 - Wettkampfspezifische Ausdauerzone: 90 bis 100 % der HFmax (Faktor 0,9 bis 1,0) = HFMAX
             */
            
            let hfTrain1min = String(Int(hfmin + (hfres * 0.5)))
            let hfTrain1max = String(Int(hfmin + (hfres * 0.6)))
            let hfTrain2max = String(Int(hfmin + (hfres * 0.7)))
            let hfTrain3max = String(Int(hfmin + (hfres * 0.8)))
            let hfTrain4max = String(Int(hfmin + (hfres * 0.9)))
            
            let hfTrain1 = hfTrain1min + " - " + hfTrain1max
            let hfTrain2 = hfTrain1max + " - " + hfTrain2max
            let hfTrain3 = hfTrain2max + " - " + hfTrain3max
            let hfTrain4 = hfTrain3max + " - " + hfTrain4max
            let hfTrain5 = hfTrain4max + " - " + String(Int(hfmax))
            
            if let ResultViewController = segue.destination as? ResultViewController {
                ResultViewController.extTrain = hfTrainE
                ResultViewController.intTrain = hfTrainI
                ResultViewController.unTrain = hfTrainU
                
                ResultViewController.hfTrain1 = hfTrain1
                ResultViewController.hfTrain2 = hfTrain2
                ResultViewController.hfTrain3 = hfTrain3
                ResultViewController.hfTrain4 = hfTrain4
                ResultViewController.hfTrain5 = hfTrain5
            }
        }
    }
}

