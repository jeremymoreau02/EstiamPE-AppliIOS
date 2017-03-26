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
    var name: String
    var price : Float
    var shippingDuration: Int
    init(name:String, price : Float, shippingDuration: Int) {
        self.name = name
        self.price = price
        self.shippingDuration = shippingDuration
    }
    
}
