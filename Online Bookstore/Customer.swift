//
//  Customer.swift
//  Online Bookstore
//
//  Created by WEI Wenzhou on 23/11/2016.
//  Copyright © 2016 WEI Wenzhou. All rights reserved.
//

import Foundation

class Customer {
    var id: Int
    var name: String
    var uni: String
    var type: Int
    var imageName: String
    var username: String
    var password: String
    var tel: String
    
    init(id: Int, name: String, uni: String, type: Int, imageName: String, username: String, password: String, tel: String) {
        self.id = id
        self.name = name
        self.uni = uni
        self.type = type
        self.imageName = imageName
        self.username = username
        self.password = password
        self.tel = tel
    }
}
