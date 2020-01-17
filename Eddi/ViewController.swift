//
//  ViewController.swift
//  Eddi
//
//  Created by Kurt Höblinger on 11.01.20.
//  Copyright © 2020 Kurt Höblinger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
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
    
    
    @IBOutlet weak var ageInput: UITextField!
    @IBOutlet weak var hfminInput: UITextField!
    
    @IBOutlet var overallView: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    NotificationCenter.default.addObserver(self,selector:#selector(self.keyboardWillShow),name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide),name:UIResponder.keyboardDidHideNotification, object: nil)
        self.setupToHideKeyboardOnTapOnView()
    }
    
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo, let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)

        scrollview.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: Notification) {
        scrollview.contentInset = UIEdgeInsets.zero
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Handle backspace/delete
        guard !string.isEmpty else {
            // Backspace detected, allow text change, no need to process the text any further
            return true
        }

        // Input Validation
        // Prevent invalid character input, if keyboard is numberpad
        if textField.keyboardType == .numberPad {

            // Check for invalid input characters
            if !CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
                // Invalid characters detected, disallow text change
                return false
            }
        }

        // Length Processing
        // Need to convert the NSRange to a Swift-appropriate type
        if let text = textField.text, let range = Range(range, in: text) {

            let proposedText = text.replacingCharacters(in: range, with: string)

            // Check proposed text length does not exceed max character count
            guard proposedText.count <= 3 else {
                // Character count exceeded, disallow text change
                return false
            }
        }

        // Allow text change
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 11
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
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
            let age = NSString(string: ageInput.text ?? "0").doubleValue
            let hfmin = NSString(string: hfminInput.text ?? "0").doubleValue
            
            let hfmax = 220.0 - age
            let hfres = hfmax - hfmin
            let hfTrainE = String(Int(hfres * 0.8 + hfmin))
            let hfTrainI = String(Int(hfres * 0.6 + hfmin))
            let hfTrainU = String(Int(hfres * 0.5 + hfmin))
            
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

