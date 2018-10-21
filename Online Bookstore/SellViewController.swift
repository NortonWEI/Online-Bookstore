//
//  SellViewController.swift
//  Online Bookstore
//
//  Created by WEI Wenzhou on 23/11/2016.
//  Copyright © 2016 WEI Wenzhou. All rights reserved.
//

import Foundation
import UIKit

class SellViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var customer: Customer?
    var books: [Book]?
    var typePicker = UIPickerView()
    var bookNameTFChecked = false
    var bookPriceTFChecked = false
    var bookCoverChecked = false
    var image: UIImage?
    
    let administrator = Customer(id: 0, name: "Administrator", uni: "HKBU", type: 0, imageName: "defaultAvatar", username: "admin", password: "admin", tel: "3411 7457")
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookNameTextField: UITextField!
    @IBOutlet weak var bookPriceTextField: UITextField!
    @IBOutlet weak var bookTypeTextField: UITextField!
    @IBOutlet weak var bookSubmitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        typePicker.dataSource = self
        typePicker.delegate = self
        bookTypeTextField.inputView = typePicker
        bookSubmitButton.isEnabled = false
        bookTypeTextField.text = "Please Select"
        bookImageView.image = UIImage(named: "DefaultCover")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bookSubmitButton.isEnabled = false
        checkEnableSubmitButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showInfoSegue") {
            let destinationViewController = segue.destination as! HelpViewController
            destinationViewController.customer = customer
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bookTypeTextField.text = "\(books![row].type)"
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var category: String?
        switch books![row].type {
        case 1:
            category = "Mathematics"
        case 2:
            category = "Computer Science"
        case 3:
            category = "Chemistry"
        case 4:
            category = "Biology"
        case 5:
            category = "Physics"
        default:
            category = "Unknown"
        }
        //category = "fdsaf"
        return category
    }
    
    func checkEnableSubmitButton() {
        if (bookNameTFChecked && bookPriceTFChecked && bookTypeTextField.text != "Please Select" && bookCoverChecked) {
            bookSubmitButton.isEnabled = true
        } else {
            bookSubmitButton.isEnabled = false
        }
    }
    
    func showBookstoreSuccessAlert() {
        let successAlert = UIAlertController(title: "Price", message: "Our official price for \(bookNameTextField.text!) is \(Float(bookPriceTextField.text!)! * 0.8)HKD. Please come to the Bookstore and we will check the book if you want to sell.", preferredStyle: UIAlertControllerStyle.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel))
        self.present(successAlert, animated: true)
    }
    
    func showSelfSellSuccessAlert() {
        let successAlert = UIAlertController(title: "Confirmation", message: "Your book is successfully uploaded. A receipt has been sent to your mailbox. Please come to the Bookstore to hand in the book within 5 working days! Please wait for potential buys to contact you.", preferredStyle: UIAlertControllerStyle.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel))
        self.present(successAlert, animated: true)
    }
    
    func passDataToBookVC() {
        let tabBarVC = self.tabBarController?.viewControllers?[0]
        let navigationVC = tabBarVC! as! UINavigationController
        let destinationViewController = navigationVC.topViewController as! BookViewController
        destinationViewController.books = books
    }
    
    func passDataToSelfSellVC() {
        let tabBarVC = self.tabBarController?.viewControllers?[1]
        let navigationVC = tabBarVC! as! UINavigationController
        let destinationViewController = navigationVC.topViewController as! SelfSellBookViewController
        destinationViewController.books = books
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        bookImageView.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        self.dismiss(animated: true, completion: nil)
        bookCoverChecked = true
        checkEnableSubmitButton()
    }
    
    func clearSellInfo() {
        self.bookImageView.image = UIImage(named: "DefaultCover")
        self.bookNameTextField.text = ""
        self.bookPriceTextField.text = ""
        self.bookTypeTextField.text = "Please Select"
        bookCoverChecked = false
    }
    
    @IBAction func uploadCoverButton(_ sender: Any) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(photoPicker, animated: true)
        
    }
    
    @IBAction func bookSubmitButton(_ sender: Any) {
        let uploadAlert = UIAlertController(title: "Upload", message: "Who should be commissioned to sell?", preferredStyle: UIAlertControllerStyle.alert)
        let bookstoreSellAction = UIAlertAction(title: "Bookstore", style: UIAlertActionStyle.default) { (action) -> Void in
            self.showBookstoreSuccessAlert()
            //self.books?.append(Book(id: self.books!.count + 1, name: self.bookNameTextField.text!, price: Float(self.bookPriceTextField.text!)!, newBook: false, image: self.image!, type: Int(self.bookTypeTextField.text!)!, owner: self.administrator))
            self.clearSellInfo()
            self.passDataToBookVC()
            self.passDataToSelfSellVC()
            self.checkEnableSubmitButton()
        }
        
        let selfSellAction = UIAlertAction(title: "Myself", style: UIAlertActionStyle.default) { (action) -> Void in
            self.showSelfSellSuccessAlert()
            self.books?.append(Book(id: self.books!.count + 1, name: self.bookNameTextField.text!, price: Float(self.bookPriceTextField.text!)!, newBook: false, image: self.image!, type: Int(self.bookTypeTextField.text!)!, owner: self.customer!))
            self.clearSellInfo()
            self.passDataToBookVC()
            self.passDataToSelfSellVC()
            self.checkEnableSubmitButton()
        }
        uploadAlert.addAction(bookstoreSellAction)
        uploadAlert.addAction(selfSellAction)
        uploadAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel))
        
        self.present(uploadAlert, animated: true)
    }
    
    @IBAction func bookNameEndEditing(_ sender: Any) {
        if let text = bookNameTextField.text {
            if (!text.isEmpty) {
                bookNameTFChecked = true
            } else {
                bookNameTFChecked = false
            }
        } else {
            bookNameTFChecked = false
        }
        checkEnableSubmitButton()
    }
    
    @IBAction func bookPriceEndEditing(_ sender: Any) {
        if let text = bookPriceTextField.text {
            if let _ = Float(text) {
                bookPriceTFChecked = true
            } else {
                bookPriceTFChecked = false
            }
        } else {
            bookPriceTFChecked = false
        }
        checkEnableSubmitButton()
    }
    
    @IBAction func bookTypeEndEditing(_ sender: Any) {
        checkEnableSubmitButton()
    }
    
}

extension SellViewController: LoginDelegate {
    func passCustomerData(customer: Customer) {
        self.customer = customer
    }
}
