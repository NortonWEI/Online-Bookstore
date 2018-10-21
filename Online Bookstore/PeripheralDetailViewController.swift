//
//  PeripheralDetailViewController.swift
//  Online Bookstore
//
//  Created by WEI Wenzhou on 24/11/2016.
//  Copyright © 2016 WEI Wenzhou. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class PeripheralDetailViewController: UIViewController {
    
    var peripheral: Peripheral?
    var peripherals: [Peripheral]?
    var customer: Customer?
    var peripheralIndex: Int?
    
    @IBOutlet weak var peripheralTitle: UINavigationItem!
    @IBOutlet weak var peripheralImageView: UIImageView!
    @IBOutlet weak var peripheralPriceLabel: UILabel!
    @IBOutlet weak var peripheralDiscountPriceLabel: UILabel!
    @IBOutlet weak var peripheralTypeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralTitle.title = peripheral?.name
        peripheralImageView.image = UIImage(named: peripheral!.imageName)
        peripheralPriceLabel.text = "Original Price: \(peripheral!.price)HKD"
        peripheralDiscountPriceLabel.text = "Discount Price: \(peripheral!.discountPrice)HKD"
        switch peripheral!.type {
        case 1:
            peripheralTypeLabel.text = "Category: Stationery"
        case 2:
            peripheralTypeLabel.text = "Category: Digital"
        case 3:
            peripheralTypeLabel.text = "Category: Living"
        case 4:
            peripheralTypeLabel.text = "Category: Clothing"
        default:
            peripheralTypeLabel.text = "Category: Unknown"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToPeripheralViewControllerSegue") {
            let destinationViewController = segue.destination as! PeripheralViewController
            destinationViewController.peripherals = peripherals
        }
    }
    
    func authenticate() {
        let auth = LAContext()
        var authError: NSError?
        
        if (auth.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)) {
            auth.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Payment Authentication", reply: { (success, error) -> Void in
                if (success) {
                    self.showSuccessAlertForLoginUser()
                } else {
                    self.showPasswordAlert()
                }
            })
        } else {
            self.showPasswordAlert()
        }
    }
    
    func showSuccessAlertForLoginUser() {
        let loginAlert = UIAlertController(title: "Thank You!", message: "You have paid \(self.peripheral!.discountPrice)HKD for \(self.peripheral!.name). A receipt has been sent to your mailbox. Please collect your \(self.peripheral!.name) at the Bookstore!", preferredStyle: UIAlertControllerStyle.alert)
        loginAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {(action) -> Void in
            self.processBuy()
        })
        self.present(loginAlert, animated: true)
    }
    
    func showPasswordAlert() {
        let passwordAlert = UIAlertController(title: "Password", message: "Please enter your password!", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) -> Void in
            let passwordTextField = passwordAlert.textFields!.first! as UITextField
            if (passwordTextField.text == self.customer!.password) {
                self.showSuccessAlertForLoginUser()
            } else {
                self.showPasswordAlert()
            }
        }
        passwordAlert.addAction(action)
        passwordAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default))
        passwordAlert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        })
        self.present(passwordAlert, animated: true)
    }
    
    func processBuy() {
        self.peripherals?.remove(at: self.peripheralIndex!)
        self.performSegue(withIdentifier: "unwindToPeripheralViewControllerSegue", sender: nil)
    }
    
    @IBAction func buyButton(_ sender: Any) {
        if (self.customer!.type == 0 || self.customer!.type == 1) {
            let visitorAlert = UIAlertController(title: "Thank You!", message: "You have paid \(peripheral!.price)HKD for \(peripheral!.name). A receipt has been sent to your mailbox. Please collect your \(peripheral!.name) at the Bookstore!", preferredStyle: UIAlertControllerStyle.alert)
            visitorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {(action) -> Void in
                self.processBuy()
            })
            self.present(visitorAlert, animated: true)
        } else {
            authenticate()
        }
    }
}
