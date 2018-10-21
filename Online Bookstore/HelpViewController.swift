//
//  InfoViewController.swift
//  Online Bookstore
//
//  Created by WEI Wenzhou on 23/11/2016.
//  Copyright © 2016 WEI Wenzhou. All rights reserved.
//

import Foundation
import UIKit

class HelpViewController: UIViewController {
    
    var customer: Customer?
    
    @IBOutlet weak var customerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var uniLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customerImageView.image = UIImage(named: customer!.imageName)
        nameLabel.text = "Name: \(customer!.name)"
        uniLabel.text = "University: \(customer!.uni)"
        switch customer!.type {
        case 0:
            typeLabel.text = "Position: Administrator"
        case 1:
            typeLabel.text = "Position: Visitor"
        case 2:
            typeLabel.text = "Position: Student"
        case 3:
            typeLabel.text = "Position: Staff"
        default:
            typeLabel.text = "Position: Unknown"
        }
        telLabel.text = "Tel: \(customer!.tel)"
    }
}
