//
//  DestinatairesViewController.swift
//  IOSAPPLI
//
//  Created by estiam on 17/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import SQLite

class DestinatairesViewController: UIViewController,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    
    var panierModel: Panier = Panier()

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var image : Photo = Photo(url: URL(string: "https://www.apple.com")!, uiimage: UIImage())
    var urlFinale: String?
    
    var cellCounter: Int = 0
    var indexCell = 0
    var destinatairesArray: [Destinataire] = [Destinataire]()
    var idU: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("description= " + image.uiimage.description)

        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        print(path)
        do{
            let db = try Connection("\(path)/db.sqlite3")
            let destinataires = Table("destinataires")
            let id = Expression<Int64>("id")
            let idMessage = Expression<Int64?>("idMessage")
            let idPhoto = Expression<Int64?>("idPhoto")
            let idUser = Expression<Int64?>("idUser")
            let civiliteDest = Expression<String?>("civilite")
            let nomDest = Expression<String?>("nom")
            let prenomDest = Expression<String?>("prenom")
            let mobileDest = Expression<String?>("mobile")
            let emailDest = Expression<String?>("email")
            let rueDest = Expression<String?>("rue")
            let cpDest = Expression<String?>("cp")
            let villeDest = Expression<String?>("ville")
            
            do{
                try db.run(destinataires.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                    t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                    t.column(idMessage, defaultValue: 0)
                    t.column(idUser, defaultValue: 0)
                    t.column(idPhoto, defaultValue: 0)
                    t.column(civiliteDest, defaultValue: "")
                    t.column(nomDest, defaultValue: "")
                    t.column(prenomDest, defaultValue: "")
                    t.column(mobileDest, defaultValue: "")
                    t.column(emailDest, defaultValue: "")
                    t.column(rueDest, defaultValue: "")
                    t.column(cpDest, defaultValue: "")
                    t.column(villeDest, defaultValue: "")
                })

                do {
                    let preferences = UserDefaults.standard
                    idU = Int64.init(preferences.string(forKey: "userId")! as String)!
                    let all = Array(try db.prepare(destinataires.filter(idUser == idU)))
                    for dest in all{
                        let d = Destinataire(id: dest[id], civilite: dest[civiliteDest]!, nom: dest[nomDest]!, prenom: dest[prenomDest]!, mobile: dest[mobileDest]!, email: dest[emailDest]!, rue: dest[rueDest]!, cp: dest[cpDest]!, ville: dest[villeDest]!)
                        
                        d.idMessage = dest[idMessage]!
                        d.idPhoto = dest[idPhoto]!
                        d.idUser = dest[idUser]!
                        
                        destinatairesArray.append(d)
                        collectionView.reloadData()
                        
                    }
                    
                } catch {
                    print("récupération impossible: \(error)")
                }
            }catch{
                print("création de la table panier impossible: \(error)")
            }
        }
        catch{
            print("connection impossible: \(error)")
        }
        
        do{
            let db = try Connection("\(path)/db.sqlite3")
            let panier = Table("panier")
            let id = Expression<Int64>("id")
            let idLivraison = Expression<Int64?>("id_livraison")
            let idUser = Expression<Int64?>("id_user")
            let idAdresse = Expression<Int64?>("id_adresse")
            let nbPhotos = Expression<Int64?>("nb_photos")
            let prixHT = Expression<Double?>("prixHT")
            let prixTTC = Expression<Double?>("prixTTC")
            let fdp = Expression<Double?>("fdp")
            let prixTotal = Expression<Double?>("prixTotal")
            let nomFacturation = Expression<String?>("nomFacturation")
            let prenomFacturation = Expression<String?>("prenomFacturation")
            let cpFacturation = Expression<String?>("cpFacturation")
            let villeFacturation = Expression<String?>("villeFacturation")
            let rueFacturation = Expression<String?>("rueFacturation")
            let status = Expression<String?>("status")
            
            do{
                try db.run(panier.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                    t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                    t.column(idLivraison)
                    t.column(idUser)
                    t.column(idAdresse)
                    t.column(nbPhotos)
                    t.column(prixHT)
                    t.column(prixTTC)
                    t.column(fdp)
                    t.column(prixTotal)
                    t.column(nomFacturation)
                    t.column(prenomFacturation)
                    t.column(cpFacturation)
                    t.column(villeFacturation)
                    t.column(rueFacturation)
                    t.column(status)
                })
                do {
                    let preferences = UserDefaults.standard
                    idU = Int64.init(preferences.string(forKey: "userId")! as String)!
                    var p = Array(try db.prepare(panier.filter(idUser == idU)))[0]
                    panierModel.id = p.get(id)
                    if var a = p.get(idLivraison){
                        panierModel.idLivraison = a
                    }
                    
                    if var a = p.get(idUser){
                        panierModel.idUser = a
                    }
                    
                    if var a = p.get(idAdresse){
                        panierModel.idAdresse = a
                    }
                    
                    if var a = p.get(nbPhotos){
                        panierModel.nbPhotos = a
                    }
                    if var a = p.get(prixHT){
                        panierModel.prixHT = a
                    }
                    
                    if var a = p.get(prixTTC){
                        panierModel.prixTTC = a
                    }
                    
                    if var a = p.get(fdp){
                        panierModel.fdp = a
                    }
                    
                    if var a = p.get(prixTotal){
                        panierModel.prixTotal = a
                    }
                    
                    if var a = p.get(nomFacturation){
                        panierModel.nomFacturation = a
                    }
                    
                    if var a = p.get(prenomFacturation){
                        panierModel.prenomFacturation = a
                    }
                    
                    if var a = p.get(cpFacturation){
                        panierModel.cpFacturation = a
                    }
                    
                    if var a = p.get(villeFacturation){
                        panierModel.villeFacturation = a
                    }
                    
                    if var a = p.get(rueFacturation){
                        panierModel.rueFacturation = a
                    }
                    
                    if var a = p.get(status){
                        panierModel.status = a
                    }
                } catch {
                    print("récupération impossible: \(error)")
                }
            }catch{
                print("création de la table panier impossible: \(error)")
            }
        }
        catch{
            print("connection impossible: \(error)")
        }

        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellDestinataire", for: indexPath as IndexPath) as! DestinataireCellCollectionViewCell
        
        var label : String = self.destinatairesArray[self.cellCounter].nom + " " + self.destinatairesArray[self.cellCounter].prenom
        
        
        cell.labelDetails.text = label
        
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(DestinatairesViewController.cellModTapped(sender:)))
        cell.imageMessage.addGestureRecognizer(tapGesture)
        cell.imageMessage.isUserInteractionEnabled = true
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(DestinatairesViewController.cellSuppTapped(sender:)))
        cell.imageSupprimer.addGestureRecognizer(tapGesture)
        cell.imageSupprimer.isUserInteractionEnabled = true
        
        self.cellCounter += 1
        if self.cellCounter >= self.destinatairesArray.count{
            self.cellCounter = 0
        }
        
        return cell
        
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.destinatairesArray.count
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
        
    }
    
    func cellModTapped(sender : UITapGestureRecognizer) {
        var tapLocation = sender.location(in: self.collView)
        var NSIndexPath = self.collView.indexPathForItem(at: tapLocation)!
        self.performSegue(withIdentifier: "segue.message", sender: self.destinatairesArray[NSIndexPath[1]])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue.message" {
            let messageDestinataireViewController = segue.destination as! MessageDestinataireViewController
            
            messageDestinataireViewController.destinataire = sender as! Destinataire
            messageDestinataireViewController.image = self.image
            messageDestinataireViewController.urlFinale = self.urlFinale
        }
        
        if segue.identifier == "segue.newDestinataire" {
            let nouveauDestinataireViewController = segue.destination as! NouveauDestinataireViewController
            
            nouveauDestinataireViewController.image = self.image
            nouveauDestinataireViewController.urlFinale = self.urlFinale
        }
        
        if segue.identifier == "segue.retEdition" {
            let editPhotoViewController = segue.destination as! EditPhotoViewController
            
            editPhotoViewController.image = self.image
            editPhotoViewController.urlFinale = self.urlFinale
        }
    }
    
    func cellSuppTapped(sender : UITapGestureRecognizer) {
        
        var tapLocation = sender.location(in: self.collView)
        var NSIndexPath = self.collView.indexPathForItem(at: tapLocation)!
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        print(path)
        do{
            let db = try Connection("\(path)/db.sqlite3")
            let destinataires = Table("destinataires")
            let id = Expression<Int64>("id")
            let idMessage = Expression<Int64?>("idMessage")
            let idPhoto = Expression<Int64?>("idPhoto")
            let idUser = Expression<Int64?>("idUser")
            let civiliteDest = Expression<String?>("civilite")
            let nomDest = Expression<String?>("nom")
            let prenomDest = Expression<String?>("prenom")
            let mobileDest = Expression<String?>("mobile")
            let emailDest = Expression<String?>("email")
            let rueDest = Expression<String?>("rue")
            let cpDest = Expression<String?>("cp")
            let villeDest = Expression<String?>("ville")
            
            do{
                try db.run(destinataires.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                    t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                    t.column(idMessage, defaultValue: 0)
                    t.column(idUser, defaultValue: 0)
                    t.column(idPhoto, defaultValue: 0)
                    t.column(civiliteDest, defaultValue: "")
                    t.column(nomDest, defaultValue: "")
                    t.column(prenomDest, defaultValue: "")
                    t.column(mobileDest, defaultValue: "")
                    t.column(emailDest, defaultValue: "")
                    t.column(rueDest, defaultValue: "")
                    t.column(cpDest, defaultValue: "")
                    t.column(villeDest, defaultValue: "")
                })
                
                do {
                    let preferences = UserDefaults.standard
                    idU = Int64.init(preferences.string(forKey: "userId")! as String)!
                    try db.run(destinataires.filter(id == self.destinatairesArray[NSIndexPath[1]].id).delete())
                    
                } catch {
                    print("récupération impossible: \(error)")
                }
            }catch{
                print("création de la table panier impossible: \(error)")
            }
        }
        catch{
            print("connection impossible: \(error)")
        }
        
        self.destinatairesArray.remove(at: NSIndexPath[1])
        collectionView.reloadData()

    }
    
    func alert(texte: String){
        //Afficher un message d'alerte
        
        //Création de l'alerte
        let alert = UIAlertController(title: "Alerte", message:
            texte, preferredStyle: UIAlertControllerStyle.alert)
        //Ajout d'une action boutton
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        //Voir alerte
        self.present(alert,animated: true, completion: nil)
        
    }
    

    @IBAction func onClickAjouter(_ sender: Any) {
        self.performSegue(withIdentifier: "segue.newDestinataire", sender: self)
    }
    
    @IBAction func onClickValider(_ sender: Any) {
        var photo = PhotoModifiee(id: 0, idMasque: 0, idFormat: 0, idPanier: 0, idUser: 0, nbPhotos: 0, name: "", uriOrigine: "", uriFinale: "", description: "", prix: 0)
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        print(path)
        do{
            let db = try Connection("\(path)/db.sqlite3")
            let photoModifiee = Table("photoModifiee")
            let idCol = Expression<Int64>("id")
            let idMasqueCol = Expression<Int64?>("idMasque")
            let idFormatCol = Expression<Int64?>("idFormat")
            let idUserCol = Expression<Int64?>("idUser")
            let idPanierCol = Expression<Int64?>("idPanier")
            let nbPhotosCol = Expression<Int64?>("nbPhotos")
            let nameCol = Expression<String?>("name")
            let uriOrigineCol = Expression<String?>("uriOriginaleCol")
            let uriFinaleCol = Expression<String?>("uriFinaleCol")
            let descriptionCol = Expression<String?>("desscriptionCol")
            let prixCol = Expression<Double?>("prix")
            
            do{
                try db.run(photoModifiee.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                    t.column(idCol, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                    t.column(idMasqueCol, defaultValue: 0)
                    t.column(idFormatCol, defaultValue: 0)
                    t.column(idPanierCol, defaultValue: 0)
                    t.column(idUserCol, defaultValue: 0)
                    t.column(nbPhotosCol, defaultValue: 1)
                    t.column(nameCol, defaultValue: "")
                    t.column(uriOrigineCol, defaultValue: "")
                    t.column(uriFinaleCol, defaultValue: "")
                    t.column(descriptionCol, defaultValue: "")
                    t.column(prixCol, defaultValue: 0)
                })
                
                do {
                    let preferences = UserDefaults.standard
                    idU = Int64.init(preferences.string(forKey: "userId")! as String)!
                    let idPanier = Int64.init(preferences.string(forKey: "idPanier")! as String)!
                    try db.run(photoModifiee.insert(idPanierCol <- idPanier, idUserCol <- idU, uriFinaleCol <- self.urlFinale))
                    
                } catch {
                    print("récupération impossible: \(error)")
                }
            }catch{
                print("création de la table panier impossible: \(error)")
            }
        }
        catch{
            print("connection impossible: \(error)")
        }
        
        do{
            let db = try Connection("\(path)/db.sqlite3")
            let panier = Table("panier")
            let nbPhotos = Expression<Int64?>("nb_photos")
            let idUser = Expression<Int64?>("id_user")
            let id = Expression<Int64?>("id")
            let prixHT = Expression<Double?>("prixHT")
            
            panierModel.nbPhotos += 1
            
            do{
                do {
                    do {
                        var prix = Array(try db.prepare(panier.filter(idUser == idU)))[0].get(prixHT)
                        print(prix)
                        if(prix == nil){
                            prix = 0
                        }
                        if try db.run(panier.filter(id == panierModel.id).update(nbPhotos <- panierModel.nbPhotos, prixHT <- (prix! + Double.init(photo.prix) ) )) > 0 {
                            print("updated alice")
                        } else {
                            print("alice not found")
                        }
                    } catch {
                        print("update failed: \(error)")
                    }
                    
                } catch {
                    print("récupération impossible: \(error)")
                }
            }catch{
                print("création de la table panier impossible: \(error)")
            }
        }
        catch{
            print("connection impossible: \(error)")
        }


    }
    
    
}
