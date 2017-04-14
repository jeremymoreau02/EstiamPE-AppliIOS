//
//  ViewController.swift
//  IOSAPPLI
//
//  Created by marcel NTOUTOUME-DOUMI on 17/12/2016.
//  Copyright © 2016 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_Synchronous
import SQLite

class ViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet var pseudoChamp: UITextField!
    @IBOutlet var mdpChamp: UITextField!
    
    var masksArray: [Masks] = [Masks]()
    var dimensionsArray: [Dimensions] = [Dimensions]()
    
    @IBAction func connexBoutton(_ sender: AnyObject) {
        let pseudo = pseudoChamp.text
        let mdp = mdpChamp.text
        
        //Si les champs sont vides
        if (((pseudo!.isEmpty) || (mdp!.isEmpty))||((pseudo == "")||(mdp == ""))) {
            //Création de l'alerte
            let alert = UIAlertController(title: "Alerte", message:"Tous les champs doivent être renseignés", preferredStyle: UIAlertControllerStyle.alert)
            //Ajout d'une action boutton
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            //Voir alerte
            self.present(alert,animated: true, completion: nil)
        
            //displayMyAlertMessage("Tous les champs sont requis");
            //return;
        }else{
            let url = NSURL(string: "http://193.70.40.193:3000/api/connection")
            var request = URLRequest(url: url as! URL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonObject: [String: String] = [
                "pseudo": pseudo!,
                "password"	: mdp!
            ]
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject)
            
            let response = Alamofire.request(request).responseJSON()
            if let json = response.result.value {
                let JSON = json as! NSDictionary
                print(JSON)
                if (JSON["error"] != nil){
                    alert(texte: "l'utilisateur est inconnu")
                    
                }else{
                    if (JSON["message"] != nil){
                        alert(texte: "Le mot de passe est incorrect")
                        
                    }else{
                    print(JSON["userId"] as! Int)
                    let preferences = UserDefaults.standard
                    
                    preferences.set(JSON["userId"] as! Int, forKey: "userId")
                    preferences.set(JSON["token"] as! String, forKey: "token")
                    
                    let date = NSDate()
                    let calendar = NSCalendar.current
                    let heures = calendar.component(.hour, from: date as Date) as NSNumber
                    let minutes = calendar.component(.minute, from: date as Date) as NSNumber
                    let secondes = calendar.component(.second, from: date as Date) as NSNumber
                    let jour = calendar.component(.day, from: date as Date) as NSNumber
                    let mois = calendar.component(.month, from: date as Date) as NSNumber
                    let annee = calendar.component(.year, from: date as Date) as NSNumber
                    
                    let stringDate = annee.stringValue + "/"+mois.stringValue+"/"+jour.stringValue+" "+heures.stringValue+":"+minutes.stringValue+":"+secondes.stringValue
                    preferences.set(stringDate as! String, forKey:"creationDate")
                    
                    
                    //  Save to disk
                    preferences.synchronize()
                         appelsApi()
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let selectionViewController = storyboard.instantiateViewController(withIdentifier: "segue.Selec")
                        self.present(selectionViewController, animated: true)
                    }
                    
                    
                    
                   
                }
                
                
            }else{
                alert(texte: "Connectez vous à internet")
            }
            
            
        
        }
        
        
    
    }
    
    func appelsApi(){
        var url = NSURL(string: "http://193.70.40.193:3000/api/mask")
        var request = URLRequest(url: url as! URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let preferences = UserDefaults.standard
        var token = preferences.string(forKey: "token")!
        request.setValue(token as String, forHTTPHeaderField: "x-access-token")
        
        
        var response = Alamofire.request(request).responseJSON()
        if let json = response.result.value {
            let JSONArray = json as! NSArray
            debugPrint(JSONArray)
            if JSONArray != nil{
                for var index in 0 ... (JSONArray.count - 1){
                    var JSON = JSONArray[index] as! NSDictionary
                    debugPrint(JSON)
                    if (JSON["error"] != nil){
                        let alert = UIAlertController(title: "Alerte", message:
                            JSON["error"]! as! String, preferredStyle: UIAlertControllerStyle.alert)
                        //Ajout d'une action boutton
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                        //Voir alerte
                        self.present(alert,animated: true, completion: nil)
                        
                    }else{
                        var mask = Masks()
                        mask.id = JSON["id"] as! Int64
                        mask.DimensionId = (JSON["Dimension"] as! NSDictionary)["id"] as! Int64
                        mask.filePath = JSON["filePath"] as! String
                        mask.name = JSON["name"] as! String
                        mask.price = JSON["price"] as! Double
                        masksArray.append(mask)
                        
                    }
                }
                let path = NSSearchPathForDirectoriesInDomains(
                    .documentDirectory, .userDomainMask, true
                    ).first!
                do{
                    let db = try Connection("\(path)/db.sqlite3")
                    let maskTable = Table("mask")
                    let idCol = Expression<Int64>("id")
                    let DimensionIdCol = Expression<Int64?>("DimensionId")
                    let filePathCol = Expression<String?>("filePath")
                    let nameCol = Expression<String?>("name")
                    let priceCol = Expression<Double?>("price")
                    
                    do{
                        try db.run(maskTable.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                            t.column(idCol, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                            t.column(DimensionIdCol, defaultValue: 0)
                            t.column(filePathCol, defaultValue: "")
                            t.column(nameCol, defaultValue: "")
                            t.column(priceCol, defaultValue: 0)
                            
                            
                        })
                        
                        do {
                            try db.run(maskTable.delete())
                            for var m in masksArray{
                                do {
                                    let rowid = try db.run(maskTable.insert(idCol <- m.id, DimensionIdCol <- m.DimensionId, filePathCol <- m.filePath, nameCol <- m.name, priceCol <- m.price))
                                    print("inserted id: \(rowid)")
                                } catch {
                                    print("insertion failed: \(error)")
                                }
                                
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
        
        url = NSURL(string: "http://193.70.40.193:3000/api/dimension")
        request = URLRequest(url: url as! URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue(token as String, forHTTPHeaderField: "x-access-token")
        
        
        response = Alamofire.request(request).responseJSON()
        if let json = response.result.value {
            let JSONArray = json as! NSArray
            debugPrint(JSONArray)
            if JSONArray != nil{
                for var index in 0 ... (JSONArray.count - 1){
                    var JSON = JSONArray[index] as! NSDictionary
                    debugPrint(JSON)
                    if (JSON["error"] != nil){
                        let alert = UIAlertController(title: "Alerte", message:
                            JSON["error"]! as! String, preferredStyle: UIAlertControllerStyle.alert)
                        //Ajout d'une action boutton
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                        //Voir alerte
                        self.present(alert,animated: true, completion: nil)
                        
                    }else{
                        var dimension = Dimensions()
                        dimension.id = JSON["id"] as! Int64
                        dimension.width = JSON["width"] as! Int64
                        dimension.name = JSON["name"] as! String
                        dimension.height = JSON["height"] as! Int64
                        dimensionsArray.append(dimension)
                        
                    }
                }
                let path = NSSearchPathForDirectoriesInDomains(
                    .documentDirectory, .userDomainMask, true
                    ).first!
                do{
                    let db = try Connection("\(path)/db.sqlite3")
                    let dimensionTable = Table("dimension")
                    let idCol = Expression<Int64>("id")
                    let nameCol = Expression<String?>("name")
                    let widthCol = Expression<Int64?>("width")
                    let heightCol = Expression<Int64?>("height")
                    
                    do{
                        try db.run(dimensionTable.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                            t.column(idCol, primaryKey: true)
                            t.column(nameCol, defaultValue: "")
                            t.column(widthCol, defaultValue: 0)
                            t.column(heightCol, defaultValue: 0)
                            
                        })
                        
                        do {
                            try db.run(dimensionTable.delete())
                            for var m in dimensionsArray{
                                do {
                                    let rowid = try db.run(dimensionTable.insert(idCol <- m.id, nameCol <- m.name, heightCol <- m.height, widthCol <- m.width))
                                    print("inserted id: \(rowid)")
                                } catch {
                                    print("insertion failed: \(error)")
                                }
                                
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


    }
    
    @IBAction func enregiBoutton(_ sender: AnyObject) {
        performSegue(withIdentifier: "segue.enreg", sender: self)
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
    
    override func viewDidLoad()
    {
        
        let preferences = UserDefaults.standard
        print(preferences)
        if let datePreferences = preferences.string(forKey: "creationDate"){
            if datePreferences != nil{
                let date = NSDate()
                let calendar = NSCalendar.current
                let heures :Int = calendar.component(.hour, from: date as Date)
                let minutes :Int = calendar.component(.minute, from: date as Date)
                let secondes :Int = calendar.component(.second, from: date as Date)
                let jour :Int = calendar.component(.day, from: date as Date)
                let mois :Int = calendar.component(.month, from: date as Date)
                let annee :Int = calendar.component(.year, from: date as Date)
                
    

                let splitDate = datePreferences.characters.split { $0 == " " }.map(String.init)
                let year :Int = Int(splitDate[0].characters.split { $0 == "/" }.map(String.init)[0])!
                let month :Int = Int(splitDate[0].characters.split { $0 == "/" }.map(String.init)[1])!
                let day :Int = Int(splitDate[0].characters.split { $0 == "/" }.map(String.init)[2])!
                let hours :Int = Int(splitDate[1].characters.split { $0 == ":" }.map(String.init)[0])!
                let mns :Int = Int(splitDate[1].characters.split { $0 == ":" }.map(String.init)[1])!
                let sec :Int = Int(splitDate[1].characters.split { $0 == ":" }.map(String.init)[2])!
                
                var anneeDiff = annee - year
                var moisDiff = mois - month
                var dayDiff = jour - day
                var heuresDiff = heures - hours
                var minutesDiff = minutes - mns
                var secondesDiff = secondes - sec
                
                if((anneeDiff == 0) && (moisDiff == 0) && (dayDiff <= 1) && ((heuresDiff * minutesDiff * secondesDiff) < 86400)){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let selectionViewController = storyboard.instantiateViewController(withIdentifier: "segue.Selec")
                    self.present(selectionViewController, animated: true)
                }
                
                
            }
        }
        super.viewDidLoad()
        
    }
        
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

