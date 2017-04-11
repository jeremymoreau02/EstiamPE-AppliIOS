//
//  PanierTableViewController.swift
//  IOSAPPLI
//
//  Created by estiam on 04/04/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import SQLite

class PanierTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var idU: Int64 = 0
    var listePhotos: [PhotoModifiee] = [PhotoModifiee]()
    var panierModel: Panier = Panier()
    
    @IBOutlet weak var prixTTCTotal: UILabel!
    @IBOutlet weak var prixHTTotal: UILabel!
    @IBOutlet weak var nbPhotosTotal: UILabel!
    @IBOutlet weak var panierTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
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
                    var preferences = UserDefaults.standard
                    idU = Int64.init(preferences.string(forKey: "userId") as! String)!
                    var idPanier = Int64.init(preferences.string(forKey: "idPanier")! as String)!
                    let all = Array(try db.prepare(photoModifiee.filter(idUserCol == idU && idPanierCol == idPanier)))
                    for var photo in all{
                        let p = PhotoModifiee(id: photo[idCol], idMasque: photo[idMasqueCol]!, idFormat: photo[idFormatCol]!, idPanier: photo[idPanierCol]!, idUser: photo[idUserCol]!, nbPhotos: photo[nbPhotosCol]!, name: photo[nameCol]!, uriOrigine: photo[uriOrigineCol]!, uriFinale: photo[uriFinaleCol]!, description: photo[descriptionCol]!, prix: Float(photo[prixCol]!))
                        
                        listePhotos.append(p)
                        panierTableView.reloadData()
                        
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
                    
                                    
                    self.prixHTTotal.text = String.init(panierModel.prixHT)
                    self.prixTTCTotal.text = String.init(panierModel.prixTTC)
                    self.nbPhotosTotal.text = String.init(panierModel.nbPhotos)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listePhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "panierCell", for: indexPath) as! panierCellTableViewCell
        let photo = listePhotos[indexPath.row] as PhotoModifiee
        
        cell.desc.text = photo.description
        cell.prix.text = String.init(photo.prix)
        cell.qte.text = String.init(photo.nbPhotos)
    
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(PanierTableViewController.moinsTapped(sender:)))
        cell.moins.addGestureRecognizer(tapGesture)
        
         tapGesture = UITapGestureRecognizer(target: self, action: #selector(PanierTableViewController.plusTapped(sender:)))
        cell.plus.addGestureRecognizer(tapGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(PanierTableViewController.suppTapped(sender:)))
        cell.suppBtn.addGestureRecognizer(tapGesture)
        
        if let url = NSURL(string: photo.uriFinale) {
            print(url)
            if let data = NSData(contentsOf: url as URL) {
                cell.img.image = UIImage(data: data as Data)
            }        
        }
        
        return cell
        
    }
    
    func plusTapped(sender : UITapGestureRecognizer) {
        var tapLocation = sender.location(in: self.panierTableView)
        var NSIndexPath = self.panierTableView.indexPathForRow(at: tapLocation)
        var photo = self.listePhotos[(NSIndexPath?[1])!]
        
        if (photo.nbPhotos < 5){
            
            panierModel.nbPhotos += 1
            panierModel.prixHT = Double(Float.init(panierModel.prixHT) - photo.prix + (photo.prix / Float.init(photo.nbPhotos)) * (Float.init(photo.nbPhotos) + 1))
            photo.prix = (photo.prix / Float.init(photo.nbPhotos)) * (Float.init(photo.nbPhotos) + 1)
            photo.nbPhotos += 1
            
            
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            do{
                let db = try Connection("\(path)/db.sqlite3")
                let panier = Table("panier")
                let nbPhotos = Expression<Int64?>("nb_photos")
                let idUser = Expression<Int64?>("id_user")
                let id = Expression<Int64?>("id")
                let prixHT = Expression<Double?>("prixHT")
                
                do{
                    do {
                        do {
                            if try db.run(panier.filter(id == panierModel.id).update(nbPhotos <- panierModel.nbPhotos)) > 0 {
                                print("updated alice")
                            } else {
                                print("alice not found")
                            }
                            if try db.run(panier.filter(id == panierModel.id).update(prixHT <- panierModel.prixHT)) > 0 {
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
                    do {
                        do {
                            if try db.run(photoModifiee.filter(idCol == photo.id).update(nbPhotosCol <- photo.nbPhotos)) > 0 {
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

            
            
            // Do any additional setup after loading the view.
        }
        
        
        self.prixHTTotal.text = String.init(panierModel.prixHT)
        self.prixTTCTotal.text = String.init(panierModel.prixTTC)
        self.nbPhotosTotal.text = String.init(panierModel.nbPhotos)
    
    
        panierTableView.reloadData()
    
    }
    
    func moinsTapped(sender : UITapGestureRecognizer) {
        var tapLocation = sender.location(in: self.panierTableView)
        var NSIndexPath = self.panierTableView.indexPathForRow(at: tapLocation)
        var photo = self.listePhotos[(NSIndexPath?[1])!]
        
        if (photo.nbPhotos > 1){
            
            panierModel.nbPhotos -= 1
            panierModel.prixHT = Double(Float.init(panierModel.prixHT) - photo.prix + (photo.prix / Float.init(photo.nbPhotos)) * (Float.init(photo.nbPhotos) - 1))
            photo.prix = (photo.prix / Float.init(photo.nbPhotos)) * (Float.init(photo.nbPhotos) - 1)
            photo.nbPhotos -= 1
            
            
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            do{
                let db = try Connection("\(path)/db.sqlite3")
                let panier = Table("panier")
                let nbPhotos = Expression<Int64?>("nb_photos")
                let idUser = Expression<Int64?>("id_user")
                let id = Expression<Int64?>("id")
                let prixHT = Expression<Double?>("prixHT")
                
                do{
                    do {
                        do {
                            if try db.run(panier.filter(id == panierModel.id).update(nbPhotos <- panierModel.nbPhotos)) > 0 {
                                print("updated alice")
                            } else {
                                print("alice not found")
                            }
                            if try db.run(panier.filter(id == panierModel.id).update(prixHT <- panierModel.prixHT)) > 0 {
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
                    do {
                        do {
                            if try db.run(photoModifiee.filter(idCol == photo.id).update(nbPhotosCol <- photo.nbPhotos)) > 0 {
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

            
            
            // Do any additional setup after loading the view.
        }
        
        
        self.prixHTTotal.text = String.init(panierModel.prixHT)
        self.prixTTCTotal.text = String.init(panierModel.prixTTC)
        self.nbPhotosTotal.text = String.init(panierModel.nbPhotos)
        
        

        panierTableView.reloadData()
        
    }
    
    func suppTapped(sender : UITapGestureRecognizer) {
        var tapLocation = sender.location(in: self.panierTableView)
        var NSIndexPath = self.panierTableView.indexPathForRow(at: tapLocation)
        var photo = self.listePhotos[(NSIndexPath?[1])!]
        
            panierModel.nbPhotos -= photo.nbPhotos
            panierModel.prixHT = panierModel.prixHT - Double.init(photo.prix)
        
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            do{
                let db = try Connection("\(path)/db.sqlite3")
                let panier = Table("panier")
                let nbPhotos = Expression<Int64?>("nb_photos")
                let idUser = Expression<Int64?>("id_user")
                let id = Expression<Int64?>("id")
                let prixHT = Expression<Double?>("prixHT")
                
                do{
                    do {
                        do {
                            if try db.run(panier.filter(id == panierModel.id).update(nbPhotos <- panierModel.nbPhotos)) > 0 {
                                print("updated alice")
                            } else {
                                print("alice not found")
                            }
                            if try db.run(panier.filter(id == panierModel.id).update(prixHT <- panierModel.prixHT)) > 0 {
                                print("updated alice")
                            } else {
                                print("alice not found")
                            }
                        } catch {
                            print("delete failed: \(error)")
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
        
        
        
        self.prixHTTotal.text = String.init(panierModel.prixHT)
        self.prixTTCTotal.text = String.init(panierModel.prixTTC)
        self.nbPhotosTotal.text = String.init(panierModel.nbPhotos)
        
        listePhotos.remove(at: (NSIndexPath?[1])!)
        
        panierTableView.reloadData()
        
    }

}
