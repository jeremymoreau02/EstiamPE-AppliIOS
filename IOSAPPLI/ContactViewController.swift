//
//  ContactViewController.swift
//  IOSAPPLI
//
//  Created by estiam on 24/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import Alamofire

class ContactViewController: UIViewController {

    
    @IBOutlet weak var objet: UITextField!
    @IBOutlet weak var message: UITextView!
    var token: String = ""
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = UserDefaults.standard
        token = preferences.string(forKey: "token")!
        
        var url = NSURL(string: "http://193.70.40.193:3000/api/users/" + preferences.string(forKey: "userId")!)
        var request = URLRequest(url: url as! URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        token = preferences.string(forKey: "token")!
        request.setValue(token as String, forHTTPHeaderField: "x-access-token")
        var response = Alamofire.request(request).responseJSON()
        if let json = response.result.value {
            let JSON = json as! NSDictionary
            print(JSON)
            if (JSON["error"] != nil){
                let alert = UIAlertController(title: "Alerte", message:
                    JSON["error"]! as! String, preferredStyle: UIAlertControllerStyle.alert)
                //Ajout d'une action boutton
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                //Voir alerte
                self.present(alert,animated: true, completion: nil)
                
            }else{
                email = JSON["email"]! as! String
                
            }
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickEnvoyer(_ sender: Any) {
        if(objet.text == ""){
            alert(texte: "objet non indiqué")
        }else{
            if(message.text == ""){
                alert(texte: "message non indiqué")
            }else{
                var url = NSURL(string: "http://193.70.40.193:3000/api/contact")
                var request = URLRequest(url: url as! URL)
                request.httpMethod = "PUT"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue(token as String, forHTTPHeaderField: "x-access-token")
                
                var jsonObject: [String: String] = [
                    "subject": objet.text!,
                    "message": message.text!,
                    "email": email
                    ]
                
                
                debugPrint(JSONSerialization.isValidJSONObject(jsonObject)) // true
                
                //let header = 	["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json", "Authorization":"a"]
                
                request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject)
                
                debugPrint(Alamofire.request(request).responseJSON { response in
                    
                    print("fguhjkl")
                    debugPrint(response)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let selectionViewController = storyboard.instantiateViewController(withIdentifier: "segue.Selec")
                    self.present(selectionViewController, animated: true)
                })
            }
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
