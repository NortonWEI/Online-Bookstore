//
//  BookDetailViewController.swift
//  Online Bookstore
//
//  Created by WEI Wenzhou on 24/11/2016.
//  Copyright © 2016 WEI Wenzhou. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class BookDetailViewController: UIViewController {
    
    var customer: Customer?
    var book: Book?
    var books: [Book]?
    var bookIndex: Int?
    
    @IBOutlet weak var detailTitle: UINavigationItem!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookPriceLabel: UILabel!
    @IBOutlet weak var bookTypeLabel: UILabel!
    @IBOutlet weak var bookUseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTitle.title = book?.name
        bookImageView.image = book?.image
        bookPriceLabel.text = "Original Price: \(book!.price)HKD"
        switch book!.type {
        case 1:
            bookTypeLabel.text = "Category: Mathematics"
        case 2:
            bookTypeLabel.text = "Category: Computer Science"
        case 3:
            bookTypeLabel.text = "Category: Chemistry"
        case 4:
            bookTypeLabel.text = "Category: Biology"
        case 5:
            bookTypeLabel.text = "Category: Physics"
        default:
            bookTypeLabel.text = "Category: Unknown"
        }
        if (book!.newBook) {
            bookUseLabel.text = "This is a new book."
        } else {
            bookUseLabel.text = "This is a used book."
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToBookViewControllerSegue") {
            let destinationViewController = segue.destination as! BookViewController
            destinationViewController.books = books
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
        let loginAlert = UIAlertController(title: "Thank You!", message: "You have paid \(self.book!.discountPrice)HKD for \(self.book!.name). A receipt has been sent to your mailbox. Please collect your \(self.book!.name) at the Bookstore!", preferredStyle: UIAlertControllerStyle.alert)
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
        for (index, book) in books!.enumerated() {
            if (book.id == self.book?.id) {
                bookIndex = index
                break
            }
        }
        self.books?.remove(at: bookIndex!)
        self.performSegue(withIdentifier: "unwindToBookViewControllerSegue", sender: nil)
    }
    
    @IBAction func buyButton(_ sender: Any) {
        if (self.customer!.type == 0 || self.customer!.type == 1) {
            let visitorAlert = UIAlertController(title: "Thank You!", message: "You have paid \(book!.price)HKD for \(self.book!.name). A receipt has been sent to your mailbox. Please collect your \(book!.name) at the Bookstore!", preferredStyle: UIAlertControllerStyle.alert)
            visitorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {(action) -> Void in
                self.processBuy()
            })
            self.present(visitorAlert, animated: true)
        } else {
            authenticate()
        }
    }
}
