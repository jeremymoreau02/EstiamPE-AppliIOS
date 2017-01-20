//
//  ViewController.swift
//  IOSAPPLI
//
//  Created by marcel NTOUTOUME-DOUMI on 17/12/2016.
//  Copyright © 2016 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import Alamofire

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
        
            let parameters: Parameters = [
                "pseudo": pseudo,
                "password": mdp
            ]
            
            let header = 	["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json", "Authorization":"a"]
            
            Alamofire.request("http://193.70.40.193:3000/api/connection", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
                
                debugPrint(response )
                
            }
            performSegue(withIdentifier: "segue.selec", sender: self)
        
        }
        
        
    
}
    
    
    @IBAction func enregiBoutton(_ sender: AnyObject) {
        performSegue(withIdentifier: "segue.enreg", sender: self)
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

