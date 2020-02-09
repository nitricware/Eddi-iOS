//
//  NWHelper.swift
//  Eddi
//
//  Created by Kurt Höblinger on 09.02.20.
//  Copyright © 2020 Kurt Höblinger. All rights reserved.
//

import Foundation
import UIKit

class NWHelper {
    static func showConfirmAlert(title: String, body: String, confirmText: String = "OK") -> UIAlertController{
        
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alert
    }
}
