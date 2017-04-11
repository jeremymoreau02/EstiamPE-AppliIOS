//
//  MessageDestinataireViewController.swift
//  IOSAPPLI
//
//  Created by estiam on 25/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import SQLite

class MessageDestinataireViewController: UIViewController {

    @IBOutlet weak var message: UITextView!
    var destinataire: Destinataire?
    
    var image : Photo = Photo(url: URL(string: "https://www.apple.com")!, uiimage: UIImage())
    var urlFinale: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    let d = try db.prepare(destinataires.filter(id == (destinataire?.id)!))
                    //message.text = d.
                    
                } catch {
                    print("récupération impossible: \(error)")
                }
            }catch{
                print("création de la table panier impossible: \(error)")
            }
        }
        catch{
            alert(texte: "connection impossible: \(error)")
            print( "connection impossible: \(error)")
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickEnvoyer(_ sender: Any) {
        if(message.text == ""){
            alert(texte: "Veuillez indiquer un message")
        }
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            print(path)
            do{
                let db = try Connection("\(path)/db.sqlite3")
                let messageDestinataire = Table("messageDestinataire")
                let id = Expression<Int64>("id")
                let messageColumn = Expression<String?>("message")
                
                do{
                    try db.run(messageDestinataire.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                        t.column(id, primaryKey: true)
                        t.column(messageColumn, defaultValue: "")
                    })
                    do{
                        let idMess = try db.run(messageDestinataire.insert(messageColumn <- message.text))
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
                                try db.run(destinataires.filter(id == (destinataire?.id)!).update(idMessage <- idMess))
                                   performSegue(withIdentifier: "segue.reloadDestAftMessage", sender: self)
                                
                            } catch {
                                print("récupération impossible: \(error)")
                            }
                        }catch{
                            print("création de la table panier impossible: \(error)")
                        }

                    }catch{
                        alert(texte: "insertion impossible: \(error)")
                        print("insertion impossible: \(error)")
                    }
                    
                }catch{
                    alert(texte: "création de la table panier impossible: \(error)")
                    print( "création de la table panier impossible: \(error)")
                }
            }
            catch{
                alert(texte: "connection impossible: \(error)")
                print( "connection impossible: \(error)")
            }
        
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue.reloadDestAftMessage" {
            let destinatairesViewController = segue.destination as! DestinatairesViewController
            
            destinatairesViewController.image = self.image
            
        }
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
    

}
