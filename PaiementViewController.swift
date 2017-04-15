//
//  Paiement View Controller.swift
//  IOSAPPLI
//
//  Created by estiam on 25/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import SQLite
import  Alamofire
import Alamofire_Synchronous

class PaiementViewController: UIViewController , PayPalPaymentDelegate{
    
    @IBOutlet weak var prixLivraisonLabel: UILabel!
    @IBOutlet weak var delaLivraisonLabel: UILabel!
    @IBOutlet weak var methodeLivraisonLabel: UILabel!
    @IBOutlet weak var nbPhotosLabel: UILabel!
    
    @IBOutlet weak var TTCLabel: UILabel!
    
    var prixTot: Double = 0
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        print(path)
        do{
            let db = try Connection("\(path)/db.sqlite3")
            let panier = Table("panier")
            let id = Expression<Int64>("id")
            let idUser = Expression<Int64?>("id_user")
            let idLivraison = Expression<Int64?>("id_livraison")
            let nbPhotos = Expression<Int64?>("nb_photos")
            let prixTTC = Expression<Double?>("prixTTC")
            let prixTotal = Expression<Double?>("prixTotal")
            
            
            do{
                do {
                    let preferences = UserDefaults.standard
                    var idU = Int64.init(preferences.string(forKey: "userId")! as String)!
                    var p = Array(try db.prepare(panier.filter(idUser == idU)))[0]
                    if var a = p.get(idLivraison){
                        var idLivraison = a
                        
                        var url = NSURL(string: "http://193.70.40.193:3000/api/shipping/" + String.init(a))
                        var request = URLRequest(url: url as! URL)
                        request.httpMethod = "GET"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        var token = preferences.string(forKey: "token")!
                        request.setValue(token as String, forHTTPHeaderField: "x-access-token")
                        
                        
                        var response = Alamofire.request(request).responseJSON()
                        if let json = response.result.value {
                            let JSON = json as! NSDictionary
                            if (JSON["error"] != nil){
                                let alert = UIAlertController(title: "Alerte", message:
                                    JSON["error"]! as! String, preferredStyle: UIAlertControllerStyle.alert)
                                //Ajout d'une action boutton
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                                //Voir alerte
                                self.present(alert,animated: true, completion: nil)
                                
                            }else{
                                prixLivraisonLabel.text = String.init(JSON["price"] as! Float)  + "€"
                                methodeLivraisonLabel.text = JSON["name"] as! String
                                delaLivraisonLabel.text = String.init(JSON["shippingDuration"] as! Int) + "jours"
                                
                                
                            }
                            
                            
                        }
                    }
                    if var a = p.get(nbPhotos){
                        nbPhotosLabel.text = String.init(a)
                        
                        
                    }
                    
                    if var a = p.get(prixTTC){
                        TTCLabel.text = String.init(a) + " €"
                    }else{
                        TTCLabel.text = "0" + " €"
                    }
                    
                    if var a = p.get(prixTotal){
                        prixTot = a
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
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "PHOTO EXPRESSO"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .both;

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
        })
        let preferences = UserDefaults.standard
        var idU = Int64.init(preferences.string(forKey: "userId")! as String)!
        var destinatairesArray: [Destinataire] = [Destinataire]()
        var messagesArray: [MessagesDestinataires] = [MessagesDestinataires]()
        var photosArray: [PhotoModifiee] = [PhotoModifiee]()
        var panierResult: Panier = Panier()
        
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
            
                
                do {
                    let preferences = UserDefaults.standard
                    idU = Int64.init(preferences.string(forKey: "userId")! as String)!
                    let all = Array(try db.prepare(destinataires.filter(idUser == idU)))
                    try db.run(destinataires.delete())
                    for dest in all{
                        let d = Destinataire(id: dest[id], civilite: dest[civiliteDest]!, nom: dest[nomDest]!, prenom: dest[prenomDest]!, mobile: dest[mobileDest]!, email: dest[emailDest]!, rue: dest[rueDest]!, cp: dest[cpDest]!, ville: dest[villeDest]!)
                        
                        d.idMessage = dest[idMessage]!
                        d.idPhoto = dest[idPhoto]!
                        d.idUser = dest[idUser]!
                        
                        let url = NSURL(string: "http://193.70.40.193:3000/api/deliverer")
                        var request = URLRequest(url: url as! URL)
                        request.httpMethod = "PUT"
                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                        request.setValue("application/json", forHTTPHeaderField: "Accept")
                        var token = preferences.string(forKey: "token")!
                        request.setValue(token as String, forHTTPHeaderField: "x-access-token")
                        
                        let jsonObject: [String: Any] = [
                            "userID": d.idUser,
                            "name": d.nom,
                            "prenom": d.prenom,
                            "street": d.rue,
                            "ZC": d.cp,
                            "city": d.ville
                        ]
                        
                        let postData2 = NSMutableData(data: ("userID="+String.init(d.idUser)).data(using: String.Encoding.utf8)!)
                        postData2.append(("&name="+d.nom).data(using: String.Encoding.utf8)!)
                        postData2.append(("&prenom="+d.prenom).data(using: String.Encoding.utf8)!)
                        postData2.append(("&street="+d.rue).data(using: String.Encoding.utf8)!)
                        postData2.append(("&ZC="+String.init(d.cp)).data(using: String.Encoding.utf8)!)
                        postData2.append(("&city="+String.init(d.ville)).data(using: String.Encoding.utf8)!)
                        
                        request.httpBody = postData2 as Data

                        
                        
                        print(NSString(data: (request.httpBody)!, encoding: String.Encoding.utf8.rawValue))
                        var response = Alamofire.request(request).responseJSON()
                        
                        if let json = response.result.value {
                            let JSON = json as! NSDictionary
                            if(JSON["success"] as! Bool){
                                d.id = JSON["delivererID"] as! Int64
                            }else{
                                d.id = 0
                            }
                            
                        }
                        
                        destinatairesArray.append(d)
                        
                    }
                    
                } catch {
                    print("récupération impossible: \(error)")
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
                    try db.run(panier.delete())
                    panierResult.id = p.get(id)
                    if var a = p.get(idLivraison){
                        panierResult.idLivraison = a
                    }
                    
                    if var a = p.get(idUser){
                        panierResult.idUser = a
                    }
                    
                    if var a = p.get(idAdresse){
                        panierResult.idAdresse = a
                    }
                    
                    if var a = p.get(nbPhotos){
                        panierResult.nbPhotos = a
                    }
                    if var a = p.get(prixHT){
                        panierResult.prixHT = a
                    }
                    
                    if var a = p.get(prixTTC){
                        panierResult.prixTTC = a
                    }
                    
                    if var a = p.get(fdp){
                        panierResult.fdp = a
                    }
                    
                    if var a = p.get(prixTotal){
                        panierResult.prixTotal = a
                    }
                    
                    if var a = p.get(nomFacturation){
                        panierResult.nomFacturation = a
                    }
                    
                    if var a = p.get(prenomFacturation){
                        panierResult.prenomFacturation = a
                    }
                    
                    if var a = p.get(cpFacturation){
                        panierResult.cpFacturation = a
                    }
                    
                    if var a = p.get(villeFacturation){
                        panierResult.villeFacturation = a
                    }
                    
                    if var a = p.get(rueFacturation){
                        panierResult.rueFacturation = a
                    }
                    
                    if var a = p.get(status){
                        panierResult.status = a
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
            let messageDestinataire = Table("messageDestinataire")
            let id = Expression<Int64>("id")
            let messageColumn = Expression<String?>("message")
            
            do{
                try db.run(messageDestinataire.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                    t.column(id, primaryKey: true)
                    t.column(messageColumn, defaultValue: "")
                })
                try db.run(messageDestinataire.delete())
                do{
                    let all = Array(try db.prepare(messageDestinataire))
                    for message in all{
                        let m = MessagesDestinataires()
                        
                        m.id = message[id]
                        m.message = message[messageColumn]!
                        
                        messagesArray.append(m)
                        
                    }
                
                    
                }catch{
                    alert(texte: "insertion impossible: \(error)")
                    print("insertion impossible: \(error)")
                }
                
            }
        }
        catch{
            alert(texte: "connection impossible: \(error)")
            print( "connection impossible: \(error)")
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
            
                
                do {
                    var preferences = UserDefaults.standard
                    idU = Int64.init(preferences.string(forKey: "userId") as! String)!
                    var idPanier = Int64.init(preferences.string(forKey: "idPanier")! as String)!
                    let all = Array(try db.prepare(photoModifiee.filter(idUserCol == idU && idPanierCol == idPanier)))
                    try db.run(photoModifiee.delete())
                    for var photo in all{
                        let p = PhotoModifiee(id: photo[idCol], idMasque: photo[idMasqueCol]!, idFormat: photo[idFormatCol]!, idPanier: photo[idPanierCol]!, idUser: photo[idUserCol]!, nbPhotos: photo[nbPhotosCol]!, name: photo[nameCol]!, uriOrigine: photo[uriOrigineCol]!, uriFinale: "", description: photo[descriptionCol]!, prix: Float(photo[prixCol]!))
                        
                        photosArray.append(p)
                        
                    }
                    
                } catch {
                    print("récupération impossible: \(error)")
                }
            
        }
        catch{
            print("connection impossible: \(error)")
        }
        
        
        var jsonItems: NSMutableArray = NSMutableArray()
        var jsonCommande: NSMutableDictionary = NSMutableDictionary()
        
        for var i in 0 ... photosArray.count - 1{
            var jsonDeliverers: NSMutableArray = NSMutableArray()
            var jsonItem: NSMutableDictionary = NSMutableDictionary()
            if(destinatairesArray.count > 0){
                for var j in 0 ... destinatairesArray.count - 1{
                    if(destinatairesArray[j].idPhoto == photosArray[i].id){
                        var jsonDeliverer: NSMutableDictionary = [
                            "id": 0,
                            "message": ""
                        ]
                        if(messagesArray.count > 0){
                            for var k in 0 ... messagesArray.count - 1{
                                if(messagesArray[k].id == destinatairesArray[j].idMessage){
                                    jsonDeliverer.setValue(destinatairesArray[j].id, forKey: "id")
                                    jsonDeliverer.setValue(messagesArray[k].message, forKey: "message")
                                }
                            }
                        }
                        
                        jsonDeliverers.add(jsonDeliverer)
                    }
                }

            }
            jsonItem.setValue(jsonDeliverers, forKey: "deliverers")
            jsonItem.setValue(2, forKey: "photoId")
            jsonItem.setValue(photosArray[i].idMasque, forKey: "maskId")
            jsonItems.add(jsonItem)
            
            let preferences = UserDefaults.standard

            let head: HTTPHeaders = [
                "x-access-token": preferences.string(forKey: "token")!,
                "Accept": "application/json",
                ]
            let URL2 = try! URLRequest(url: "http://193.70.40.193:3000/api/add-photo", method: .put, headers: head)
            
            var urlA = photosArray[i].uriOrigine
            print(urlA)
            var tabUrl = urlA.components(separatedBy: "/")
            var urlGood = tabUrl[tabUrl.count - 1]
            var usId = photosArray[i].idUser as Int64
            var ui = UIImage(contentsOfFile: urlA)!
            var jpeg = UIImageJPEGRepresentation(UIImage(contentsOfFile: urlA)!, 80)!
            
            print(urlGood)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(UIImage(contentsOfFile: urlA)!, 80)! , withName: "photo", fileName: urlGood, mimeType: "image/jpg")
                    multipartFormData.append(String.init(usId).data(using: .utf8)!, withName: "userID")
                
            }, with: URL2, encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON{
                        response in
                        if let data = response.result.value{
                            print(data)
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    
                }
                
            })
            sleep(5000)
            
            
        }
        jsonCommande.setValue(jsonItems, forKey: "Items")
        jsonCommande.setValue("Pending", forKey: "status")
        jsonCommande.setValue(panierResult.prixTotal, forKey: "totalPriceHT")
        jsonCommande.setValue(panierResult.idLivraison, forKey: "shippingMethodId")
        jsonCommande.setValue(panierResult.idAdresse, forKey: "billingAddressId")
        jsonCommande.setValue(panierResult.idUser, forKey: "userID")
        jsonCommande.setValue(panierResult.nomFacturation, forKey: "name")
        jsonCommande.setValue(panierResult.prenomFacturation, forKey: "firstname")

        
        let url = NSURL(string: "http://193.70.40.193:3000/api/order")
        var request = URLRequest(url: url as! URL)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        var token = preferences.string(forKey: "token")!
        request.setValue(token as String, forHTTPHeaderField: "x-access-token")
        
        
        //let header = 	["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json", "Authorization":"a"]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonCommande)
        
        print(NSString(data: (request.httpBody)!, encoding: String.Encoding.utf8.rawValue))
        
        debugPrint(Alamofire.request(request).responseJSON { response in
            
            print(response)
            debugPrint(response.result.value as! NSDictionary)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let selectionViewController = storyboard.instantiateViewController(withIdentifier: "segue.Selec")
             self.present(selectionViewController, animated: true)
        })

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func paypal(_ sender: Any) {
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        var number = NSDecimalNumber.init(string: nf.string(from: NSDecimalNumber.init(value: prixTot))!)
        
        let payment = PayPalPayment(amount: number , currencyCode: "EUR", shortDescription: "Photos", intent: .sale)
         
         if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self as! PayPalPaymentDelegate)
            present(paymentViewController!, animated: true, completion: nil)
            
         }
         else {
         // This particular payment will always be processable. If, for
         // example, the amount was negative or the shortDescription was
         // empty, this payment wouldn't be processable, and you'd want
         // to handle that here.
         alert(texte: "Payment not processable: \(payment)")
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
