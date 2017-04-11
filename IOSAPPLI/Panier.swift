//
//  Destinataire.swift
//  IOSAPPLI
//
//  Created by estiam on 18/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import Foundation
import UIKit

class Panier{
    var id: Int64 = 0
    var idLivraison: Int64 = 0
    var idAdresse: Int64 = 0
    var idUser: Int64 = 0
    var nbPhotos: Int64 = 0
    var prixHT: Double = 0
    var prixTTC: Double = 0
    var fdp: Double = 0
    var prixTotal: Double = 0
    var nomFacturation: String = ""
    var prenomFacturation: String = ""
    var cpFacturation: String = ""
    var villeFacturation: String = ""
    var rueFacturation: String = ""
    var status: String = ""
}
