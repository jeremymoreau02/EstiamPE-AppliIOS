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

class ViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet var pseudoChamp: UITextField!
    @IBOutlet var mdpChamp: UITextField!
    
    
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
                    let alert = UIAlertController(title: "Alerte", message:
                        "l'utilisateur est inconnu", preferredStyle: UIAlertControllerStyle.alert)
                    //Ajout d'une action boutton
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    //Voir alerte
                    self.present(alert,animated: true, completion: nil)
                    
                }else{
                    if (JSON["message"] != nil){
                        let alert = UIAlertController(title: "Alerte", message:
                            "Le mot de passe est incorrect", preferredStyle: UIAlertControllerStyle.alert)
                        //Ajout d'une action boutton
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                        //Voir alerte
                        self.present(alert,animated: true, completion: nil)
                        
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
                    }
                }
                
            }
            
            performSegue(withIdentifier: "segue.selec", sender: self)
        
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
                
                let c = NSDateComponents()
                c.year = year
                c.month = month
                c.day = day+1
                c.minute = mns
                c.hour = hours
                c.second = sec
                
                // Get NSDate given the above date components
                let datePref = NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: c as DateComponents)
                
                
                let jhgj = date.compare(datePref!)
                
                if date.compare(datePref! as Date) == ComparisonResult.orderedDescending{
                    performSegue(withIdentifier: "segue.selec", sender: self)
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

