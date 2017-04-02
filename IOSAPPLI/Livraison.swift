//
//  Livraison.swift
//  IOSAPPLI
//
//  Created by estiam on 26/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import Foundation
import UIKit

class Livraison{
    var id: Int64
    var name: String
    var price : Float
    var shippingDuration: Int
    init(id: Int64, name:String, price : Float, shippingDuration: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.shippingDuration = shippingDuration
    }
    
}
