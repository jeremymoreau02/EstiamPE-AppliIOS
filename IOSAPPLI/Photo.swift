//
//  Photo.swift
//  IOSAPPLI
//
//  Created by estiam on 27/02/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import Foundation
import UIKit

class Photo{
    var url: URL
    var uiimage : UIImage
    init(url:URL, uiimage : UIImage) {
        self.url = url
        self.uiimage = uiimage
        
    }
    
    func getImage() -> UIImage{
        return self.uiimage
    }
    
    
}
