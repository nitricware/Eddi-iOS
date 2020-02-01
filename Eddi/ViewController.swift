//
//  ViewController.swift
//  Eddi
//
//  Created by Kurt Höblinger on 11.01.20.
//  Copyright © 2020 Kurt Höblinger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hintStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hintCell", for: indexPath) as! HintCellCollectionViewCell
        cell.hintLabel.text = hintStrings[indexPath.item]
        return cell
    }
    
    
    
    let numbers: [String] = [
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
    
    let hintStrings: [String] = [
        "First hint",
        "Second hint",
        "Third hint"
    ]
    
    let numberToolbar: UIToolbar = UIToolbar()
    
    let cellScale: CGFloat = 0.7
    
    
    @IBOutlet weak var ageInput: UITextField!
    @IBOutlet weak var hfminInput: UITextField!
    
    @IBOutlet var overallView: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var hintCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    NotificationCenter.default.addObserver(self,selector:#selector(self.keyboardWillShow),name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide),name:UIResponder.keyboardDidHideNotification, object: nil)
        self.setupToHideKeyboardOnTapOnView()
        //numberToolbar.barStyle = UIBarStyle.blackTranslucent
        numberToolbar.items=[
            UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.dismissNumpad))
        ]

        numberToolbar.sizeToFit()

        ageInput.inputAccessoryView = numberToolbar //do it for every relevant textfield if there are more than one
        hfminInput.inputAccessoryView = numberToolbar
        
        let screenSize = UIScreen.main.bounds.size
        
        let cellWidth = floor(screenSize.width * cellScale)
        let cellHeight = floor(screenSize.height * cellScale)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let hintLayout = hintCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        hintLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        hintLayout.sectionInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.hintCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
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
    
    @objc func dismissNumpad() {
        ageInput.resignFirstResponder()
        hfminInput.resignFirstResponder()
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "results") {
            let karvonenCalculator = KarvonenCalculator()
            karvonenCalculator.age = NSString(string: ageInput.text ?? "0").doubleValue
            karvonenCalculator.hfmin = NSString(string: hfminInput.text ?? "0").doubleValue
            karvonenCalculator.calcHFMax()
            karvonenCalculator.calcHFRes()
            karvonenCalculator.calculateKarvonen()
            karvonenCalculator.calculateEdwardsZones()
            
            if let ResultViewController = segue.destination as? ResultViewController {
                ResultViewController.extTrain = String(karvonenCalculator.karvonenResult.extensiveTraining)
                ResultViewController.intTrain = String(karvonenCalculator.karvonenResult.intensiveTraining)
                ResultViewController.unTrain = String(karvonenCalculator.karvonenResult.untrained)
                
                ResultViewController.hfTrain1 = String(karvonenCalculator.edwardsResult.healthZone.bottom) + " - " + String(karvonenCalculator.edwardsResult.healthZone.top)
                ResultViewController.hfTrain2 = String(karvonenCalculator.edwardsResult.fatZone.bottom) + " - " + String(karvonenCalculator.edwardsResult.fatZone.top)
                ResultViewController.hfTrain3 = String(karvonenCalculator.edwardsResult.aerobicZone.bottom) + " - " + String(karvonenCalculator.edwardsResult.aerobicZone.top)
                ResultViewController.hfTrain4 = String(karvonenCalculator.edwardsResult.anaerobicZone.bottom) + " - " + String(karvonenCalculator.edwardsResult.anaerobicZone.top)
                ResultViewController.hfTrain5 = String(karvonenCalculator.edwardsResult.competitionZone.bottom) + " - " + String(karvonenCalculator.edwardsResult.competitionZone.top)
            }
        }
    }
}

