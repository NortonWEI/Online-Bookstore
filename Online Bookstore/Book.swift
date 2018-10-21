//
//  Book.swift
//  Online Bookstore
//
//  Created by WEI Wenzhou on 23/11/2016.
//  Copyright © 2016 WEI Wenzhou. All rights reserved.
//

import Foundation
import UIKit

class Book {
    let id: Int
    let name: String
    let price: Float
    let discountPrice: Float
    let secondHandPrice: Float
    var newBook: Bool
    let image: UIImage
    let type: Int
    var owner: Customer
    
    init(id: Int, name: String, price: Float, newBook: Bool, image: UIImage, type: Int, owner: Customer) {
        self.id = id
        self.name = name
        self.price = price
        self.discountPrice = price * 0.9
        self.secondHandPrice = price * 0.7
        self.newBook = newBook
        self.image = image
        self.type = type
        self.owner = owner
    }
}
