//
//  PhotoModifiee.swift
//  IOSAPPLI
//
//  Created by estiam on 04/04/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import Foundation
import UIKit

class PhotoModifiee{
    var id: Int64 = 0
    var idMasque: Int64 = 0
    var idFormat: Int64 = 0
    var idPanier: Int64 = 0
    var idUser: Int64 = 0
    var nbPhotos: Int64 = 0
    var name: String = ""
    var uriOrigine: String = ""
    var uriFinale: String = ""
    var description: String = ""
    var prix: Float = 0
    
    init(id: Int64, idMasque: Int64, idFormat: Int64, idPanier: Int64, idUser: Int64, nbPhotos: Int64, name: String, uriOrigine: String, uriFinale: String, description: String, prix: Float){
        
        self.id = id
        self.idMasque = idMasque
        self.idFormat = idFormat
        self.idPanier = idPanier
        self.idUser = idUser
        self.nbPhotos = nbPhotos
        self.name = name
        self.uriOrigine = uriOrigine
        self.uriFinale = uriFinale
        self.description = description
        self.prix = prix
    }
}
