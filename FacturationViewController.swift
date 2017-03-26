//
//  FacturationViewController.swift
//  IOSAPPLI
//
//  Created by estiam on 25/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import Alamofire

class FacturationViewController: UIViewController {

    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var prenom: UITextField!
    @IBOutlet weak var rue: UITextField!
    @IBOutlet weak var cp: UITextField!
    @IBOutlet weak var ville: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickValider(_ sender: Any) {
        if((nom.text! == "") || (prenom.text! == "") || (rue.text! == "") || (cp.text! == "") || (ville.text! == "")){
            alert(texte: "Veuillez renseigner tout les champs")
        }
        let url = NSURL(string: "http://193.70.40.193:3000/api/address")
        var request = URLRequest(url: url as! URL)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let preferences = UserDefaults.standard
        let idU = Int.init(preferences.string(forKey: "userId")! as String)!
        
        let jsonObject: [String: Any] = [
            "ZC": cp.text!,
            "street": rue.text!,
            "city": ville.text!,
            "lastname": nom.text!,
            "firstname": prenom.text!,
            "type": "Billing",
            "userId": idU
        ]
        
        debugPrint(JSONSerialization.isValidJSONObject(jsonObject)) // true
        
        //let header = 	["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json", "Authorization":"a"]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject)
        
        debugPrint(Alamofire.request(request).responseJSON { response in
            
            print("fguhjkl")
            debugPrint(response)
        })
        
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
