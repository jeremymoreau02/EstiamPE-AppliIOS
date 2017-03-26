//
//  Destinataire.swift
//  IOSAPPLI
//
//  Created by estiam on 18/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import Foundation
import UIKit

class Destinataire{
    var id: Int64
    var idPhoto: Int64
    var idMessage: Int64
    var idUser: Int64
    var civilite: String
    var nom: String
    var prenom: String
    var mobile: String
    var email: String
    var rue: String
    var cp: String
    var ville: String
    var isSelected: Bool
    
    init(id: Int64, civilite: String, nom: String, prenom: String, mobile: String, email: String, rue: String, cp: String, ville: String) {
        self.civilite = civilite
        self.cp = cp
        self.email = email
        self.id = id
        self.mobile = mobile
        self.nom = nom
        self.prenom = prenom
        self.rue = rue
        self.ville = ville
        self.idPhoto = 0
        self.idUser = 0
        self.idMessage = 0
        self.isSelected = false
        
    }
    
    
}
