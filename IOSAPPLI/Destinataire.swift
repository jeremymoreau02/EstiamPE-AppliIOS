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
    var id: Int
    var idPhoto: Int
    var idMessage: Int
    var idUser: Int
    var civilite: String
    var nom: String
    var prenom: String
    var mobile: String
    var email: String
    var rue: String
    var cp: String
    var ville: String
    var isSelected: Bool
    
    init(id: Int, civilite: String, nom: String, prenom: String, mobile: String, email: String, rue: String, cp: String, ville: String) {
        self.civilite = civilite
        self.cp = cp
        self.email = email
        self.id=id
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
    
    func getId() -> Int{
        return self.id
    }
    
    
    func setId(id: Int){
        self.id = id
    }
    
    func getIdUser() -> Int{
        return self.idUser
    }
    
    func setIdUser(idUser: Int){
        self.idUser = idUser
    }
    
    func getIdMessage() -> Int{
        return self.idMessage
    }
    
    func setIdMessage(idMessage: Int){
        self.idMessage = idMessage
    }
    
    func getIdPhoto() -> Int{
        return self.idPhoto
    }
    
    func setIdPhoto(idPhoto: Int){
        self.idPhoto = idPhoto
    }
    
    func getCivilite() -> String{
        return self.civilite
    }
    
    func setCivilite(civilite: String){
        self.civilite = civilite
    }
    
    func getCp() -> String{
        return self.cp
    }
    
    func setCp(cp: String){
        self.cp = cp
    }
    
    func getEmail() -> String{
        return self.email
    }
    
    func setEmail(email: String){
        self.email = email
    }
    
    func getMobile() -> String{
        return self.mobile
    }
    
    func setMobile(mobile: String){
        self.mobile = mobile
    }
    
    func getNom() -> String{
        return self.nom
    }
    
    func setNom(nom: String){
        self.nom = nom
    }
    
    func getPrenom() -> String{
        return self.prenom
    }
    
    func setPrenom(prenom: String){
        self.prenom = prenom
    }
    
    func getRue() -> String{
        return self.rue
    }
    
    func setRue(rue: String){
        self.rue = rue
    }
    
    func getVille() -> String{
        return self.ville
    }
    
    func setVille(ville: String){
        self.ville = ville
    }
    
    func getIsSelected() -> Bool{
        return self.isSelected
    }
    
    func setIsSelected(isSelected: Bool){
        self.isSelected = isSelected
    }
    
    
}
