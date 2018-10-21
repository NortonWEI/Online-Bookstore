//
//  LoginViewController.swift
//  Online Bookstore
//
//  Created by WEI Wenzhou on 23/11/2016.
//  Copyright © 2016 WEI Wenzhou. All rights reserved.
//

import Foundation
import UIKit

protocol LoginDelegate {
    func passCustomerData(customer: Customer)
}

class LoginViewController: UIViewController {
    
    let emptyAlert = UIAlertController(title: "Empty Login Message", message: "Please input your username and password!", preferredStyle: UIAlertControllerStyle.alert)
    
    let wrongAlert = UIAlertController(title: "Wrong Login Message", message: "Please check your username and password!", preferredStyle: UIAlertControllerStyle.alert)
    
    var loginActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let bookstore = Customer(id: 0, name: "Administrator", uni: "HKBU", type: 0, imageName: "defaultAvatar", username: "admin", password: "admin", tel: "3411 7457")
    let visitor = Customer(id: 1, name: "Visitor", uni: "Unknown", type: 1, imageName: "defaultAvatar", username: "", password: "", tel: "Unknown")
    let alfredoMilani = Customer(id: 2, name: "Dr. Milani, ALFREDO", uni: "HKBU", type: 3, imageName: "milaniAvatar", username: "milani", password: "alfredo", tel: "3411 7082")
    let weiWenzhou = Customer(id: 3, name: "WEI Wenzhou", uni: "HKBU", type: 2, imageName: "nortonAvatar", username: "13252542", password: "wenzhou", tel: "3411 7892")
    let wangYan = Customer(id: 4, name: "WANG Yan", uni: "HKBU", type: 2, imageName: "wangYanAvatar", username: "13251112", password: "yan", tel: "3411 7983")
    let hoYeeHung = Customer(id: 5, name: "HO Yee Hung", uni: "HKBU", type: 2, imageName: "hoYeeHungAvatar", username: "13212214", password: "yeehung", tel: "3411 5678")
    let yeungYeeMei = Customer(id: 6, name: "YEUNG Yee Mei", uni: "HKBU", type: 2, imageName: "yeungYeeMeiAvatar", username: "13215191", password: "yeemei", tel: "3411 7895")
    let leungWingTung = Customer(id: 7, name: "LEUNG Wing Tung", uni: "HKBU", type: 2, imageName: "defaultAvatar", username: "14212781", password: "wingtung", tel: "3411 5696")
    
    var customers: [Customer]?
    var loginDelegateBook: LoginDelegate?
    var loginDelegateSelfSellBook: LoginDelegate?
    var loginDelegatePeripheral: LoginDelegate?
    var loginDelegateSell: LoginDelegate?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var visitorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customers = [bookstore, alfredoMilani, weiWenzhou, wangYan, hoYeeHung, yeungYeeMei, leungWingTung]
        emptyAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        wrongAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        self.hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginSegue" || segue.identifier == "visitorSegue") {
            let tabBarDestinationVC = segue.destination as! UITabBarController
            
            let naviDestinationVCBook = tabBarDestinationVC.viewControllers![0] as! UINavigationController
            let destinationViewControllerBook = naviDestinationVCBook.topViewController as! BookViewController
            self.loginDelegateBook = destinationViewControllerBook
            
            let naviDestinationVCSelfSellBook = tabBarDestinationVC.viewControllers![1] as! UINavigationController
            let destinationViewControllerSelfSellBook = naviDestinationVCSelfSellBook.topViewController as! SelfSellBookViewController
            self.loginDelegateSelfSellBook = destinationViewControllerSelfSellBook
            
            let naviDestinationVCPeripheral = tabBarDestinationVC.viewControllers![2] as! UINavigationController
            let destinationViewControllerPeripheral = naviDestinationVCPeripheral.topViewController as! PeripheralViewController
            self.loginDelegatePeripheral = destinationViewControllerPeripheral
            
            let naviDestinationVCSell = tabBarDestinationVC.viewControllers![3] as! UINavigationController
            let destinationViewControllerSell = naviDestinationVCSell.topViewController as! SellViewController
            self.loginDelegateSell = destinationViewControllerSell
        }
    }
    
    func clearLoginInfo() {
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    func checkLogin() {
        if (usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty) {
            self.present(emptyAlert, animated: true)
            clearLoginInfo()
        } else {
            var loginCustomer: Customer?
            for customer in customers! {
                if (usernameTextField.text == customer.username && passwordTextField.text == customer.password) {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    loginDelegateBook?.passCustomerData(customer: customer)
                    loginDelegateSelfSellBook?.passCustomerData(customer: customer)
                    loginDelegatePeripheral?.passCustomerData(customer: customer)
                    loginDelegateSell?.passCustomerData(customer: customer)
                    loginCustomer = customer
                    break
                }
            }
            if let _ = loginCustomer {} else {
                self.present(wrongAlert, animated: true)
                clearLoginInfo()
            }
        }
        
        loginActivityIndicator.stopAnimating()
        loginButton.isEnabled = true
        visitorButton.isEnabled = true
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        clearLoginInfo()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        loginActivityIndicator.center = self.view.center
        loginActivityIndicator.hidesWhenStopped = true
        loginActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(loginActivityIndicator)
        loginButton.isEnabled = false
        visitorButton.isEnabled = false
        loginActivityIndicator.startAnimating()
        perform(#selector(LoginViewController.checkLogin), with: nil, afterDelay: 2)
    }
    
    @IBAction func visitorButton(_ sender: Any) {
        self.performSegue(withIdentifier: "visitorSegue", sender: sender)
        loginDelegateBook?.passCustomerData(customer: visitor)
        loginDelegateSelfSellBook?.passCustomerData(customer: visitor)
        loginDelegatePeripheral?.passCustomerData(customer: visitor)
        loginDelegateSell?.passCustomerData(customer: visitor)
    }
}
