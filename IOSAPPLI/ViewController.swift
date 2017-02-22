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
                if (JSON["error"] != nil){
                    let alert = UIAlertController(title: "Alerte", message:
                        JSON["error"]! as! String, preferredStyle: UIAlertControllerStyle.alert)
                    //Ajout d'une action boutton
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    //Voir alerte
                    self.present(alert,animated: true, completion: nil)
                    
                }else{
                    print(JSON["userId"] as! Int)
                    let preferences = UserDefaults.standard
                    
                    preferences.set(JSON["userId"] as! Int, forKey: "userId")
                    
                    //  Save to disk
                    preferences.synchronize()
                }
                
            }
            
            let preferences = UserDefaults.standard
            debugPrint(preferences.integer(forKey: "userId"))
            
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
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
        
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

