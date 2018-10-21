//
//  Peripheral.swift
//  Online Bookstore
//
//  Created by WEI Wenzhou on 24/11/2016.
//  Copyright © 2016 WEI Wenzhou. All rights reserved.
//

import Foundation

class Peripheral {
    
    let id: Int
    let name: String
    let price: Float
    let discountPrice: Float
    let imageName: String
    let type: Int
    
    init(id: Int, name: String, price: Float, imageName: String, type: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.discountPrice = price * 0.9
        self.imageName = imageName
        self.type = type
    }
}
